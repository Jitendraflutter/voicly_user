import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:voicly/core/route/routes.dart';

import 'caller_overlay_controller.dart';

class CallController extends GetxController {
  // ───── OBS ─────
  var callStatus = "Dialing...".obs;
  var callDuration = 0.obs;
  var isMuted = false.obs;
  var isSpeaker = false.obs;
  var myVolume = 0.obs;
  var remoteVolume = 0.obs;

  // ───── INTERNAL ─────
  late RtcEngine _engine;
  RxInt agoraRemoteUserId = 0.obs;
  Timer? _timer;
  StreamSubscription? _callStatusSub;
  bool _engineInitialized = false;
  bool _isEndingCall = false;

  // 🟢 NEW: VIDEO OBS ─────
  var isCameraOn = false.obs;
  var isFrontCamera =
      true.obs; // Changed to .obs so UI can react when they join!

  RtcEngine get engine => _engine;

  static const _channel = MethodChannel('com.voicly.app/call_service');

  // ───── ARGUMENTS ─────
  final CallOverlayController overlayController =
      Get.find<CallOverlayController>();
  final String channelId = Get.arguments['channel_id'];
  final String rtcToken = Get.arguments['rtc_token'];
  final String callerName = Get.arguments['caller_name'];
  final String callerUid = Get.arguments['caller_uid'] ?? "";
  final String callerAvatar = Get.arguments['caller_avatar'] ?? "";
  final String receiverToken = Get.arguments['receiver_token'] ?? "";
  final bool isReceiver = Get.arguments['is_receiver'] ?? false;
  // 🟢 NEW: Determine Call Type
  final bool isVideoCall = Get.arguments['is_video'] ?? false;
  // ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _startRingtone();
  }

  @override
  void onReady() {
    super.onReady();
    _resetCallDocThenStart();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _callStatusSub?.cancel();

    if (_engineInitialized) {
      _engine.leaveChannel();
      _engine.release();
      _engineInitialized = false;
    }
    super.onClose();
  }

  // ───── RESET FIRESTORE BEFORE LISTEN ─────
  Future<void> _resetCallDocThenStart() async {
    try {
      await FirebaseFirestore.instance.collection('calls').doc(channelId).set({
        'status': 'calling',
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Firestore reset error: $e");
    }

    _listenToCallStatus();
    await _initAgora();
  }

  // ───── RINGTONE ─────
  void _startRingtone() {
    if (!isReceiver) {
      FlutterRingtonePlayer().play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true,
        volume: 0.5,
      );
    }
  }

  // ───── AGORA INIT ─────
  Future<void> _initAgora() async {
    try {
      _engine = createAgoraRtcEngine();

      await _engine.initialize(
        const RtcEngineContext(
          appId: "26b2a0b4c5fa4595b6c1285f34b4a4eb",
          channelProfile: ChannelProfileType.channelProfileCommunication,
          audioScenario: AudioScenarioType.audioScenarioMeeting,
        ),
      );

      await _engine.enableAudio();

      // 🟢 NEW: If it's a video call, enable the video module!
      if (isVideoCall) {
        await _engine.enableVideo();
        await _engine.startPreview();
        isCameraOn.value = true;
        isSpeaker.value = true; // Video calls usually default to speakerphone
      }
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      await _engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioMeeting,
      );

      await _engine.enableAudioVolumeIndication(
        interval: 500,
        smooth: 3,
        reportVad: true,
      );

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            debugPrint("Joined Agora: ${connection.channelId}");
          },

          onUserJoined: (connection, remoteUid, elapsed) async {
            if (isVideoCall) {
              try {
                await _engine.setEnableSpeakerphone(true);
              } catch (e) {
                debugPrint("Speakerphone sync warning: $e");
              }
            }
            FlutterCallkitIncoming.setCallConnected(channelId);
            agoraRemoteUserId.value = remoteUid;
            FlutterRingtonePlayer().stop();
            callStatus.value = "Connected";
            _startTimer();

            // 🔥 START BACKGROUND SERVICE
            await _channel.invokeMethod('startCallService');
          },

          onConnectionStateChanged: (connection, state, reason) {
            debugPrint("Agora state: $state reason: $reason");

            if (state == ConnectionStateType.connectionStateDisconnected &&
                reason !=
                    ConnectionChangedReasonType.connectionChangedLeaveChannel &&
                callStatus.value == "Connected") {
              endCall();
            }
          },

          onAudioVolumeIndication:
              (connection, speakers, speakerNumber, totalVolume) {
                for (var speaker in speakers) {
                  if (speaker.uid == 0) {
                    myVolume.value = speaker.volume ?? 0;
                  } else if (speaker.uid == agoraRemoteUserId) {
                    remoteVolume.value = speaker.volume ?? 0;
                  }
                }
              },

          onUserOffline: (connection, remoteUid, reason) {
            agoraRemoteUserId.value = 0;
            endCall();
          },

          onError: (err, msg) {
            debugPrint("Agora error: $err — $msg");
          },
        ),
      );

      await _engine.joinChannel(
        token: rtcToken,
        channelId: channelId,
        uid: 0,
        options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          publishCameraTrack: isVideoCall,
          autoSubscribeVideo: isVideoCall,
        ),
      );

      _engineInitialized = true;
    } catch (e) {
      debugPrint("Agora init error: $e");
      endCall();
    }
  }

  // ───── TIMER ─────
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration.value++;
    });
  }

  String get formattedTime {
    final m = callDuration.value ~/ 60;
    final s = callDuration.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ───── CONTROLS ─────
  void toggleMute() {
    isMuted.value = !isMuted.value;
    _engine.muteLocalAudioStream(isMuted.value);
  }

  void toggleSpeaker() {
    isSpeaker.value = !isSpeaker.value;
    _engine.setEnableSpeakerphone(isSpeaker.value);
  }

  // ───── FIRESTORE LISTENER ─────
  void _listenToCallStatus() {
    _callStatusSub = FirebaseFirestore.instance
        .collection('calls')
        .doc(channelId)
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) return;
          if (_isEndingCall) return;

          final status = snapshot.data()?['status'] ?? "";
          if (status == "end_call") {
            FlutterRingtonePlayer().stop();
            callStatus.value = "Call Ended";
            Future.delayed(const Duration(milliseconds: 300), endCall);
          }
        });
  }

  // ───── END CALL ─────
  void endCall() async {
    if (_isEndingCall) return;
    _isEndingCall = true;

    overlayController.isMinimized.value = false;
    _timer?.cancel();
    _callStatusSub?.cancel();
    FlutterRingtonePlayer().stop();

    if (_engineInitialized) {
      await _engine.leaveChannel();
      await _engine.release();
      _engineInitialized = false;
    }

    // 🔥 STOP BACKGROUND SERVICE
    await _channel.invokeMethod('stopCallService');

    await FlutterCallkitIncoming.endAllCalls();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('calls')
          .doc(channelId)
          .get();

      if (doc.data()?['status'] != 'end_call') {
        await FirebaseFirestore.instance
            .collection('calls')
            .doc(channelId)
            .update({'status': 'end_call'});
      }
    } catch (_) {}

    Get.delete<CallController>(force: true);
    if (isVideoCall) {
      if (Get.currentRoute == AppRoutes.VIDEO_CALL_SCREEN) {
        Get.back(result: "end_call");
      }
      return;
    }
    if (Get.currentRoute == AppRoutes.CALL_SCREEN) {
      Get.back(result: "end_call");
    }
  }

  // ───── RETURN FROM OVERLAY ─────
  void returnToCallScreen() {
    overlayController.isMinimized.value = false;
    Get.toNamed(
      isVideoCall ? AppRoutes.VIDEO_CALL_SCREEN : AppRoutes.CALL_SCREEN,
      arguments: {
        'channel_id': channelId,
        'rtc_token': rtcToken,
        'caller_name': callerName,
        'caller_uid': callerUid,
        'caller_avatar': callerAvatar,
        'is_video': isVideoCall,
      },
    );
  }

  // 🟢 NEW: VIDEO CONTROLS ─────
  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
    _engine.muteLocalVideoStream(!isCameraOn.value);
  }

  void switchCamera() {
    isFrontCamera.value = !isFrontCamera.value;
    _engine.switchCamera();
  }
}

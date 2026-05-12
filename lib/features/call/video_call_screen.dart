import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/caller_controller.dart';
import 'package:voicly/controller/caller_overlay_controller.dart';

import '../../networks/cloud_function_services.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  CallController get controller => Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (result == "end_call") return;
        Get.find<CallOverlayController>().isMinimized.value = true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // 1. BACKGROUND: Remote Video or Waiting Screen
              Obx(() {
                if (controller.agoraRemoteUserId.value != 0) {
                  return SizedBox.expand(
                    child: controller.isLocalUserInPip.value
                        // 🟢 Remote User is Fullscreen
                        ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: controller.engine,
                              canvas: VideoCanvas(
                                uid: controller.agoraRemoteUserId.value,
                              ),
                              connection: RtcConnection(
                                channelId: controller.channelId,
                              ),
                            ),
                          )
                        // 🟢 Local User is Fullscreen
                        : AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: controller.engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          ),
                  );
                } else {
                  // While ringing/dialing
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.callerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.callStatus.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),

              // 2. FOREGROUND (PiP): Local User Video
              Obx(() {
                if (controller.isCameraOn.value) {
                  return AnimatedPositioned(
                    // 🟢 The Secret: 0ms when dragging, 300ms for the magnetic snap!
                    duration: Duration(
                      milliseconds: controller.isDragging.value ? 0 : 300,
                    ),
                    curve: Curves
                        .easeOutBack, // Gives it a slight "bouncy" feel like WhatsApp
                    top: controller.pipTop.value,
                    right: controller.pipRight.value,

                    child: GestureDetector(
                      onTap: controller.isLocalUserInPip.toggle,
                      onPanStart: (details) {
                        controller.isDragging.value = true;
                      },
                      onPanUpdate: (details) {
                        controller.pipTop.value += details.delta.dy;
                        controller.pipRight.value -= details.delta.dx;
                      },
                      onPanEnd: (details) {
                        controller.isDragging.value = false;
                        controller
                            .snapPipToCorner(); // 🟢 Trigger the math function when they let go!
                      },

                      child: Container(
                        width: 110,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: controller.isLocalUserInPip.value
                              // 🟢 Local User is in the PiP
                              ? AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: controller.engine,
                                    canvas: const VideoCanvas(uid: 0),
                                  ),
                                )
                              // 🟢 Remote User is in the PiP
                              : AgoraVideoView(
                                  controller: VideoViewController.remote(
                                    rtcEngine: controller.engine,
                                    canvas: VideoCanvas(
                                      uid: controller.agoraRemoteUserId.value,
                                    ),
                                    connection: RtcConnection(
                                      channelId: controller.channelId,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Hide if camera is off
              }),

              // 3. TOP LEFT: Timer and Status indicator
              Positioned(
                top: 20,
                left: 20,
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      controller.callStatus.value == "Connected"
                          ? controller.formattedTime
                          : controller.callStatus.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),

              // 4. BOTTOM: Control Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Camera Toggle
                      Obx(
                        () => _iconButton(
                          icon: controller.isCameraOn.value
                              ? Icons.videocam
                              : Icons.videocam_off,
                          isActive:
                              !controller.isCameraOn.value, // Red when off
                          activeColor: Colors.redAccent,
                          onTap: controller.toggleCamera,
                        ),
                      ),

                      // Mute Toggle
                      Obx(
                        () => _iconButton(
                          icon: controller.isMuted.value
                              ? Icons.mic_off
                              : Icons.mic,
                          isActive:
                              controller.isMuted.value, // White when muted
                          onTap: controller.toggleMute,
                        ),
                      ),

                      // End Call
                      _iconButton(
                        icon: Icons.call_end,
                        isActive: true,
                        activeColor: Colors.redAccent,
                        size: 64,
                        onTap: () {
                          Get.find<CloudFunctionService>().updateCallStatus(
                            channelId: controller.channelId,
                            status: "end_call_by_user",
                            otherUserToken: controller.receiverToken,
                          );
                          controller.endCall();
                        },
                      ),

                      // Switch Camera
                      _iconButton(
                        icon: Icons.cameraswitch,
                        isActive: false,
                        onTap: controller.switchCamera,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Same button helper you used in the Audio UI
  Widget _iconButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color activeColor = Colors.white,
    Color inactiveColor = Colors.white24,
    double size = 52,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black87 : Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}

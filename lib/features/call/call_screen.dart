import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/caller_controller.dart';
import 'package:voicly/controller/caller_overlay_controller.dart';
import 'package:voicly/features/call/pulsing_avatar.dart';

import '../../networks/cloud_function_services.dart';

class CallView extends StatelessWidget {
  const CallView({super.key});

  CallController get controller => Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (result == "end_call") {
          return;
        }
        Get.find<CallOverlayController>().isMinimized.value = true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.deepPurple.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Caller Profile Pic
                SizedBox(
                  height: 170,
                  child: PulsingAvatar(
                    imageUrl: controller.callerAvatar,
                    volumeLevel: controller.remoteVolume,
                    baseSize: 130,
                  ),
                ),
                const SizedBox(height: 20),

                // Caller Name
                Text(
                  controller.callerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Dynamic Status / Timer
                Obx(
                  () => Text(
                    controller.callStatus.value == "Connected"
                        ? controller.formattedTime
                        : controller.callStatus.value,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),

                const Spacer(),

                // Control Bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute Toggle
                      Obx(
                        () => _iconButton(
                          icon: controller.isMuted.value
                              ? Icons.mic_off
                              : Icons.mic,
                          isActive: controller.isMuted.value,
                          activeColor: Colors.white, // Highlights when muted
                          onTap: controller.toggleMute,
                        ),
                      ),

                      // End Call (Static visual, no toggle state needed)
                      _iconButton(
                        icon: Icons.call_end,
                        isActive: true,
                        activeColor: Colors.redAccent,
                        size: 72, // Larger centerpiece
                        onTap: () {
                          Get.find<CloudFunctionService>().updateCallStatus(
                            channelId: controller.channelId,
                            status: "end_call_by_user",
                            otherUserToken: controller.receiverToken,
                          );
                          controller.endCall();
                        },
                      ),

                      // Speaker Toggle
                      Obx(
                        () => _iconButton(
                          icon: controller.isSpeaker.value
                              ? Icons.volume_up
                              : Icons.volume_down,
                          isActive: controller.isSpeaker.value,
                          activeColor: Colors.white,
                          onTap: controller.toggleSpeaker,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required bool isActive, // New: Tracks state
    required VoidCallback onTap,
    Color activeColor = Colors.white,
    Color inactiveColor = Colors.white24,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size,
        width: size,
        decoration: BoxDecoration(
          // High contrast for active state, subtle for inactive
          color: isActive ? activeColor : inactiveColor,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          // Icon color flips to match background contrast
          color: isActive ? Colors.black87 : Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}

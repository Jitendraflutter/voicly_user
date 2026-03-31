import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🟢 Added import
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voicly/core/constant/app_assets.dart';
import 'package:voicly/widget/screen_wrapper.dart';

import '../../controller/call_history_controller.dart';
import '../../controller/home_controller.dart';
import 'model/call_history_model.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CallHistoryController());
    final callController = Get.put(HomeController());

    return ScreenWrapper(
      visibleAppBar: true,
      title: "Call History",
      child: Obx(() {
        if (controller.isInitialLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPeach),
          );
        }
        if (controller.callLogs.isEmpty) {
          return Center(
            child: Text(
              "No calls yet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ), // 🟢 Scaled
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.callLogs.length,
          itemBuilder: (context, index) {
            final CallHistoryModel call = controller.callLogs[index];

            final bool isOutgoing = call.callerUid == controller.currentUserId;
            final String displayName =
                (isOutgoing ? call.receiverName : call.callerName) ?? "Unknown";
            final String displayAvatar =
                (isOutgoing ? call.receiverAvatar : call.callerAvatar) ??
                AppAssets.userUrl;
            final String formattedTime = call.timestamp != null
                ? DateFormat('MMM dd, hh:mm a').format(call.timestamp!)
                : "Unknown Time";

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.h, // 🟢 Scaled
                horizontal: 16.w, // 🟢 Scaled
              ),
              child: Dismissible(
                key: Key(call.historyId ?? index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => controller.deleteCallLog(call.historyId!),
                background: _buildDeleteBackground(),
                child: GlassContainer(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r, // 🟢 Scaled
                        backgroundImage: NetworkImage(displayAvatar),
                        backgroundColor: AppColors.primaryPeach.withValues(alpha:
                          0.1,
                        ),
                      ),
                      SizedBox(width: 16.w), // 🟢 Scaled
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackground,
                                fontSize: 17.sp, // 🟢 Scaled
                              ),
                            ),
                            SizedBox(height: 4.h), // 🟢 Scaled
                            Row(
                              children: [
                                Icon(
                                  Icons.call_made,
                                  size: 14.sp, // 🟢 Scaled
                                  color: Colors.green,
                                ),
                                SizedBox(width: 6.w), // 🟢 Scaled
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 13.sp, // 🟢 Scaled
                                    color: AppColors.onBackground.withValues(alpha:
                                      0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h), // 🟢 Scaled
                            Text(
                              "Duration: ${call.durationSeconds ?? 0}s",
                              style: TextStyle(
                                fontSize: 12.sp, // 🟢 Scaled
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryPeach,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          CallButton(
                            icon: CupertinoIcons.phone_fill,
                            color: AppColors.onPrimary,
                            // onTap: () => callController.startCall(caller),
                          ),
                          SizedBox(width: 8.w), // 🟢 Scaled
                          CallButton(
                            icon: CupertinoIcons.videocam_fill,
                            color: AppColors.onPrimary.withValues(alpha:0.4),
                            // onTap: () => callController.startCall(caller, isVideo: true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // 🟢 Scaled
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(20.r), // 🟢 Scaled
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 25.w), // 🟢 Scaled
      child: Icon(
        CupertinoIcons.delete,
        color: Colors.white,
        size: 24.sp, // 🟢 Scaled
      ),
    );
  }
}

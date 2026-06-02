import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicly/core/constants/app_text.dart';

class ExitConfirmSheet extends StatelessWidget {
  const ExitConfirmSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const ExitConfirmSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(-0.4, -0.6),
          radius: 1.5,
          colors: [
            AppColors.primaryPeachShade,
            Color(0xFF2B2F3A),
            Color(0xFF0D0F14),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.r),
          topRight: Radius.circular(50.r),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          SizedBox(height: 28.h),

          // Icon badge
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryPeach.withValues(alpha: 0.25),
                  AppColors.primaryPeach.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppColors.primaryPeach.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Icon(
              CupertinoIcons.square_arrow_left,
              color: AppColors.primaryPeach,
              size: 28.sp,
            ),
          ),

          SizedBox(height: 20.h),

          // Title
          Text(
            AppText.exitApp.tr,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: 8.h),

          // Subtitle
          Text(
            AppText.exitAppConfirmMessage.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.onBackground.withValues(alpha: 0.55),
              height: 1.5,
            ),
          ),

          SizedBox(height: 30.h),

          // Action buttons
          Row(
            children: [
              // Stay button
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Get.back(),
                  child: Container(
                    height: 52.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      AppText.stayOnApp.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Exit button
              Expanded(
                child: AppButton(
                  text: AppText.exitApp.tr,
                  icon: CupertinoIcons.square_arrow_right,
                  onPressed: () {
                    Get.back();
                    SystemNavigator.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:voicly/controller/auth/phone_auth_controller.dart';
import 'package:voicly/widget/screen_wrapper.dart'; // Adjust for your AppColors/ScreenWrapper
// import 'package:voicly/controller/phone_auth_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber; // Pass the phone number here so we can show it

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final PhoneAuthController authCtrl = Get.find<PhoneAuthController>();
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Styling for the OTP input boxes
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
    );

    return ScreenWrapper(
      visibleAppBar: true,
      title: "", // Keep it clean
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),

            // 🔹 Header
            Text(
              "Verify OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "We have sent a 6-digit verification code to\n${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),

            // 🔹 Pinput Field (Handles Auto-fill automatically!)
            Pinput(
              controller: pinController,
              length: 6, // Firebase defaults to 6 digit OTPs
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: AppColors.primaryPeach),
                color: Colors.white.withOpacity(0.12),
              ),
              submittedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: AppColors.success),
              ),
              showCursor: true,
              onCompleted: (pin) {
                // Auto-verify when all 6 digits are typed!
                authCtrl.verifyOTP(pin);
              },
            ),
            SizedBox(height: 40.h),

            // 🔹 Verify Button
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: authCtrl.isLoading.value
                      ? null
                      : () {
                          if (pinController.text.length == 6) {
                            authCtrl.verifyOTP(pinController.text);
                          } else {
                            Get.snackbar(
                              "Incomplete",
                              "Please enter all 6 digits.",
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPeach,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: authCtrl.isLoading.value
                      ? SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Verify & Proceed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              );
            }),
            SizedBox(height: 30.h),

            // 🔹 Resend Timer & Button
            Obx(() {
              if (authCtrl.canResend.value) {
                return TextButton(
                  onPressed: () {
                    pinController.clear();
                    authCtrl.verifyPhoneNumber(widget.phoneNumber);
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: AppColors.primaryPeach,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return Text(
                  "Resend Code in 00:${authCtrl.timerSeconds.value.toString().padLeft(2, '0')}",
                  style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

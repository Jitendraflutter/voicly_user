import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/auth/phone_auth_controller.dart';

class LoginBottomSheet extends StatefulWidget {
  LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController phoneController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();

  // Initialize or find your auth controller
  final PhoneAuthController authCtrl = Get.put(PhoneAuthController());

  @override
  void initState() {
    _phoneFocus.requestFocus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        // bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.w,
        right: 24.w,
        top: 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.dark, // Use your app's background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white60,
            offset: Offset(0, -1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wraps content perfectly
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Little drag handle indicator at the top
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // 🔹 Title & Subtitle
          Text(
            "Welcome to Voicly",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Enter your mobile number to continue. We will send you an OTP to verify.",
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 30.h),

          // 🔹 Phone Number Input Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Country Code Prefix
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "+91",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(height: 30.h, width: 1.w, color: Colors.white24),
                // Text Field
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        10,
                      ), // Limit to 10 digits
                    ],
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),

          // 🔹 Submit Button
          Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: authCtrl.isLoading.value
                    ? null // Disable button while loading
                    : () {
                        String number = phoneController.text.trim();
                        if (number.length == 10) {
                          // Format number with country code and send
                          authCtrl.verifyPhoneNumber("+91$number");
                        } else {
                          Get.snackbar(
                            "Invalid Number",
                            "Please enter a valid 10-digit mobile number.",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryPeach, // Or your primary button gradient
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 5,
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
                        "Send OTP",
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

          SizedBox(height: 30.h), // Bottom padding
        ],
      ),
    );
  }
}

import 'package:voicly/core/constants/app_text.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:voicly/controller/auth/login_controller.dart';
import 'package:voicly/core/constant/app_assets.dart';
import 'package:voicly/core/constant/app_svg.dart';

import 'base_layout.dart';
import 'mobile_number_sheet.dart';

class PhoneInputScreen extends StatelessWidget {
  final VoidCallback onNext;
  const PhoneInputScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return BaseAuthLayout(
      title: "Let's Get Started!", // More energetic title
      subtitle: "Join our community and start your journey with just one tap.",
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Added a decorative illustration area to make the screen look full
          Container(
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
          ),

          const SizedBox(height: 40),

          // Enhanced description text
          const Text(
            AppText.experienceSeamlessAccessToYourAccountNoPasswordsNoWaitingjustSecureAndFastAuthentication,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey, height: 1.5),
          ),

          const SizedBox(height: 40),

          _buildSocialButton(
            leadingIcon: Icon(Icons.phone_android_sharp, color: Colors.white),
            text: AppText.mobleNumber,
            onPressed: () async {
              Get.bottomSheet(
                LoginBottomSheet(),
                isScrollControlled:
                    true, // 🟢 VERY IMPORTANT: Allows the sheet to move up when the keyboard opens
                backgroundColor:
                    Colors.transparent, // Keeps your rounded top corners clean
              );
            },
          ),
          SizedBox(height: 20),
          _buildSocialButton(
            leadingIcon: SvgPicture.asset(AppSvg.google, width: 24, height: 24),
            text: AppText.signInWithGoogle,
            onPressed: () async {
              try {
                context.loaderOverlay.show();
                await controller.signInWithGoogleFirebase();
              } finally {
                context.loaderOverlay.hide();
              }
            },
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: AppText.byContinuingYouAgreeToOur,
                style: TextStyle(color: AppColors.grey, fontSize: 12),
                children: [
                  TextSpan(
                    text: AppText.termsOfService,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Helpers.launchURL(AppText.termsOfService),
                  ),
                  const TextSpan(text: AppText.and),
                  TextSpan(
                    text: AppText.privacyPolicy,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Helpers.launchURL(AppText.privacyPolicy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    final Widget? leadingIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56, // Slightly taller for better touch target
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ?leadingIcon,
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.onBackground,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

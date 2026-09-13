import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/core.dart';
import 'package:voicly/core/constants/app_text.dart';
import 'widget/base_layout.dart';
import 'widget/custom_text_field.dart';

class ProfileSetupScreen extends StatelessWidget {
  final VoidCallback onComplete;
  const ProfileSetupScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: AppText.aboutYou.tr,
      subtitle: AppText.helpUsKnowYou.tr,
      child: Column(
        children: [
          CustomTextField(
            hint: AppText.fullName.tr,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hint: AppText.dateOfBirth.tr,
            icon: Icons.cake_outlined,
            readOnly: true,
          ),
          const SizedBox(height: 40),
          AppButton(text: AppText.completeSetup.tr, onPressed: onComplete),
        ],
      ),
    );
  }
}

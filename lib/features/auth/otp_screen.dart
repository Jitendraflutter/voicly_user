import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/core.dart';
import 'package:voicly/core/constants/app_text.dart';
import 'package:voicly/features/auth/widget/base_layout.dart';

class OTPScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OTPScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: AppText.verifyPhone.tr,
      subtitle: AppText.weveSentCode.tr,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => _otpBox()),
          ),
          const SizedBox(height: 40),
          AppButton(text: AppText.verify.tr, onPressed: onNext),
          TextButton(
            onPressed: () {},
            child: Text(
              AppText.resendCode.tr,
              style: const TextStyle(color: AppColors.primaryPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10),
        ],
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(border: InputBorder.none, counterText: ""),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

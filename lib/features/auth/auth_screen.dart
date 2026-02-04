import 'package:flutter/material.dart';
import 'package:voicly/core/route/app_route.dart';
import 'package:voicly/features/auth/widget/auth_button.dart';
import 'package:voicly/features/auth/widget/base_auth_widget.dart';
import 'package:voicly/features/auth/widget/phone_input.dart';
import 'package:voicly/features/auth/widget/profile_detail_widget.dart';
import 'package:voicly/features/home/home_screen.dart';
import '../../core/constants/app_colors.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PhoneInputScreen(onNext: _nextPage),
          _OTPScreen(onNext: _nextPage),
          ProfileDetailsScreen(
            onComplete: () {
              AppRoute.pushAndRemoveAll(HomeScreen());
            },
          ),
        ],
      ),
    );
  }
}

class _OTPScreen extends StatelessWidget {
  final VoidCallback onNext;
  const _OTPScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: "Verify Phone",
      subtitle: "We've sent a 4-digit code to your number",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => _otpBox()),
          ),
          const SizedBox(height: 40),
          gradientButton(text: "Verify", onTap: onNext),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Resend Code",
              style: TextStyle(color: AppColors.primaryPurple),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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

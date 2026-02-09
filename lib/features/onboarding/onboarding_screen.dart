import 'package:flutter/material.dart';
import 'package:voicly_caller/widget/app_button.dart';
import 'package:voicly_caller/widget/screen_wrapper.dart';
import '../../core/constants/app_colors.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Become a Creator',
      'description':
          'Join the Voicly community as a verified caller. Share your voice and connect globally.',
      'icon': Icons.mic_none_rounded,
    },
    {
      'title': 'Talk & Earn Points',
      'description':
          'Every second counts. Earn 10 points for every second spent on a caller. 1s = 10 Points.',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Flexible Freedom',
      'description':
          'You decide when to go online. Work on your terms with total privacy and security.',
      'icon': Icons.timer_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _buildPage(index),
          ),

          // Skip Button using your Peach color for visibility against the dark top
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.primaryPeach,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Bottom Section
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 48),

                // Button using your primary Purple
                AppButton(
                  text: _currentPage == _onboardingData.length - 1
                      ? 'Start Earning'
                      : 'Next',
                  onPressed: () {
                    if (_currentPage == _onboardingData.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container using your Lavender
          Container(
            height: 240,
            width: 240,
            decoration: BoxDecoration(
              color: AppColors.primaryLavender.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _onboardingData[index]['icon'],
              size: 100,
              color: AppColors
                  .primaryPeach, // Contrast against the purple background
            ),
          ),
          const SizedBox(height: 50),
          Text(
            _onboardingData[index]['title']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _onboardingData[index]['description']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryPeach
            : AppColors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

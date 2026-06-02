import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/language_controller.dart';
import 'package:voicly/features/language/language_screen.dart';
import 'package:voicly/widget/screen_wrapper.dart';

class BaseAuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const BaseAuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      // Added Scaffold to provide a proper white background and keyboard handling
      child: Stack(
        children: [
          // Decorative top gradient splash
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.logoGradient.withOpacity(0.2),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              // 1. Added LayoutBuilder to get screen constraints
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // 2. Added ScrollView to prevent overflow on small screens
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints
                          .maxHeight, // 3. Force column to be at least screen height
                    ),
                    child: IntrinsicHeight(
                      // 4. Allows Spacer() to work correctly
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Language picker — top right
                            Align(
                              alignment: Alignment.centerRight,
                              child: Obx(() {
                                final langCode = Get.find<LanguageController>().currentLangCode;
                                return CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Get.bottomSheet(
                                    const LanguageSelectionScreen(asSheet: true),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.15),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          langCode == 'hi' ? '🇮🇳' : '🇺🇸',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          langCode == 'hi' ? 'हिन्दी' : 'EN',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onBackground,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 11,
                                          color: AppColors.onBackground.withValues(alpha: 0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 60),

                            // This is where your PhoneInputScreen content goes
                            // If you use Spacer() in the child, it will now work!
                            Expanded(child: child),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class BaseAuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const BaseAuthLayout({super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorative top gradient splash
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.logoGradient.withValues(alpha:0.2),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onBackground.withValues(alpha:0.6),
                  ),
                ),
                const SizedBox(height: 60),
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
*/

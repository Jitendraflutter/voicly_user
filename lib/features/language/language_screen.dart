import 'package:flutter/material.dart';
import 'package:voicly/widget/screen_wrapper.dart';
import '../../core/constants/app_colors.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'Hindi', 'code': 'hi', 'flag': '🇮🇳'},
    {'name': 'Spanish', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'French', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'Arabic', 'code': 'ar', 'flag': '🇦🇪'},
  ];

  String selectedLanguageCode = 'en';

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: languages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = selectedLanguageCode == lang['code'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguageCode = lang['code']!;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryPurple
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          lang['name']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryPurple,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient:
                    AppColors.logoGradient, // Using your signature gradient
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Handle language change logic here
                  print("Selected Language: $selectedLanguageCode");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

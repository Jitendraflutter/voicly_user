import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/controller/language_controller.dart';
import 'package:voicly/core/constants/app_text.dart';
import 'package:voicly/widget/screen_wrapper.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key, this.asSheet = false});

  final bool asSheet;

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'हिन्दी', 'code': 'hi', 'flag': '🇮🇳'},
  ];

  late String selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    selectedLanguageCode = Get.find<LanguageController>().currentLangCode;
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();
    if (widget.asSheet) return content;
    return ScreenWrapper(
      visibleAppBar: true,
      title: AppText.selectLanguage.tr,
      child: content,
    );
  }

  Widget _buildContent() {
    if (widget.asSheet) {
      return Container(
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppText.selectLanguage.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSheetItems(),
            const SizedBox(height: 20),
            AppButton(
              text: AppText.confirm.tr,
              onPressed: () {
                Get.find<LanguageController>().changeLanguage(selectedLanguageCode);
                Get.back();
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(child: _buildPageList()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: AppButton(
            text: AppText.confirm.tr,
            onPressed: () {
              Get.find<LanguageController>().changeLanguage(selectedLanguageCode);
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  // Lightweight version for bottom sheet — no blur per item
  Widget _buildSheetItems() {
    return Column(
      children: languages.map((lang) {
        final isSelected = selectedLanguageCode == lang['code'];
        return GestureDetector(
          onTap: () => setState(() => selectedLanguageCode = lang['code']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryPeach.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryPeach.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.08),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  lang['name']!,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.onBackground,
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primaryPeach, key: ValueKey('check'))
                      : const SizedBox(width: 24, key: ValueKey('empty')),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Full-page list keeps GlassContainer blur (used from profile route)
  Widget _buildPageList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: languages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lang = languages[index];
        final isSelected = selectedLanguageCode == lang['code'];
        return GestureDetector(
          onTap: () => setState(() => selectedLanguageCode = lang['code']!),
          child: GlassContainer(
            borderColor: isSelected ? AppColors.primaryPeach : Colors.transparent,
            blur: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Text(
                    lang['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: AppColors.primaryPeach),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

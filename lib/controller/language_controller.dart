import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicly/core/utils/local_storage.dart';

class LanguageController extends GetxController {
  final _langCode = 'en'.obs;

  String get currentLangCode => _langCode.value;

  @override
  void onInit() {
    super.onInit();
    _langCode.value = LocalStorage.getLanguage();
  }

  void changeLanguage(String langCode) {
    final locale = langCode == 'hi' ? const Locale('hi', 'IN') : const Locale('en', 'US');
    Get.updateLocale(locale);
    LocalStorage.setLanguage(langCode);
    _langCode.value = langCode;
  }
}

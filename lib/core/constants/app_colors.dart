import 'package:flutter/material.dart';

class AppColors {
  // Core Brand Colors (Extracted from your logo)
  static const Color primaryPeach = Color(0xFFFDB4B8);
  static const Color primaryLavender = Color(0xFFBCB1F1);
  static const Color primaryPurple = Color(0xFF9E8CF4);

  // Background & Surface
  static const Color background = Color(0xFFF8F9FF); // Very light tint for app bg
  static const Color surface = Colors.white;

  // Theme Variables
  static const Color primary = Color(0xFFE5A6D3); // Mid-point of your gradient
  static const Color secondary = primaryLavender;

  // Status Colors (Matching the soft pastel vibe)
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);
  static const Color success = Color(0xFF81C784);

  // Text Colors
  static const Color onBackground = Color(0xFF2D2D2D);
  static const Color onSurface = Color(0xFF2D2D2D);
  static const Color onPrimary = Colors.white;

  // The Signature Gradient from your logo
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryPeach,
      primaryLavender,
      primaryPurple,
    ],
  );

  // Soft Background Gradient for UI Screens
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF0F1), // Soft peach tint
      Color(0xFFF3F1FF), // Soft lavender tint
    ],
  );
}
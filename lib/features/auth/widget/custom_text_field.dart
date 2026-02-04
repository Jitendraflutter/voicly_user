import 'package:flutter/material.dart';
import 'package:voicly/core/constants/app_colors.dart';

Widget customTextField({
  required String hint,
  required IconData icon,
  TextInputType? keyboardType,
  bool readOnly = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: TextField(
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        icon: Icon(icon, color: AppColors.primaryPurple),
        hintText: hint,
        border: InputBorder.none,
      ),
    ),
  );
}

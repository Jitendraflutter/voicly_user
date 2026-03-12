import 'package:core/constants/app_colors.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/core.dart';
import 'package:core/utils/helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../widget/screen_wrapper.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? _selectedReason;
  final TextEditingController _confirmController = TextEditingController();
  bool _isConfirmEnabled = false;

  final List<String> _reasons = [
    "I no longer find the service useful",
    "It’s too expensive",
    "Technical issues / Bugs",
    "Privacy concerns",
    "Too many notifications",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Delete Account',
      visibleAppBar: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Warning Header
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Deletions are permanent. You will lose all saved data, and active subscriptions, for more please read delete page on voicly.in.",
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // 2. Reason Selection
            Text(
              "Why are you leaving?",
              style: TextStyle(color: AppColors.onBackground),
            ),
            ..._reasons.map(
              (reason) => RadioListTile<String>(
                activeColor: AppColors.primaryPeach,
                selectedTileColor: AppColors.primaryPeach,

                title: Text(
                  reason,
                  style: TextStyle(color: AppColors.onBackground),
                ),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (val) => setState(() => _selectedReason = val),
                contentPadding: EdgeInsets.zero,
              ),
            ),

            SizedBox(height: 24),

            // 3. Manual Confirmation
            Text(
              "Type 'DELETE' to confirm:",
              style: TextStyle(color: AppColors.grey),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              onChanged: (val) =>
                  setState(() => _isConfirmEnabled = val == "DELETE"),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "DELETE",

                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            SizedBox(height: 32),

            // 4. Action Buttons
            AppButton(
              onPressed: () => Navigator.pop(context),
              text: 'Keep My Account',
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: _isConfirmEnabled && _selectedReason != null
                    ? () => Get.bottomSheet(
                        DeleteAccountScreen(),
                        isScrollControlled: true,
                      )
                    : null,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text("Permanently Delete My Data"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                      "By continuing, you confirm that you understand and agree to our ",
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                  children: [
                    TextSpan(
                      text: "Account Deletion Policy",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPeach,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            Helpers.launchURL(AppStrings.accountDeletion),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

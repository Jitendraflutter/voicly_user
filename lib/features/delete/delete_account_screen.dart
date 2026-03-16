import 'package:core/constants/app_colors.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/utils/helpers.dart';
import 'package:core/widget/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controller/delete_account_controller.dart';
import '../../widget/screen_wrapper.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});

  // Inject Controller
  final controller = Get.put(DeleteAccountController());
  final TextEditingController _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Delete Account',
      visibleAppBar: true,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.infoText.value,
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
              const SizedBox(height: 24),

              // 2. Dynamic Reason Selection
              Text(
                "Why are you leaving?",
                style: TextStyle(color: AppColors.onBackground),
              ),
              ...controller.reasons.map(
                (reason) => RadioListTile<String>(
                  activeColor: AppColors.primaryPeach,
                  title: Text(
                    reason,
                    style: TextStyle(color: AppColors.onBackground),
                  ),
                  value: reason,
                  groupValue: controller.selectedReason.value,
                  onChanged: (val) => controller.selectedReason.value = val,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Manual Confirmation
              Text(
                "Type 'DELETE' to confirm:",
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmController,
                onChanged: (val) =>
                    controller.isConfirmEnabled.value = (val == "DELETE"),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "DELETE",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 32),

              // 4. Action Buttons
              AppButton(onPressed: () => Get.back(), text: 'Keep My Account'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed:
                      (controller.isConfirmEnabled.value &&
                          controller.selectedReason.value != null)
                      ? () {
                          // Handle actual deletion logic here
                        }
                      : null,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Permanently Delete My Data"),
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
        );
      }),
    );
  }
}

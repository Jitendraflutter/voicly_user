import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountSheet extends StatelessWidget {
  const DeleteAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF), // Hardcoded White
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const Text(
              "Delete Account?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121), // Hardcoded Dark Grey
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "This action is irreversible. All your photos, messages, and credits will be permanently removed from our servers.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575), // Hardcoded Medium Grey
              ),
            ),
            const SizedBox(height: 24),

            // Warning Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE), // Hardcoded Light Red
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEF5350)),
              ),
              child: const Text(
                "Note: Deleting your account will also cancel your Pro subscription immediately.",
                style: TextStyle(color: Color(0xFFC62828), fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFBDBDBD)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Color(0xFF424242)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your delete logic here
                      Get.back();
                      Get.snackbar(
                        "Request Sent",
                        "Your account will be deleted within 24 hours.",
                        backgroundColor: const Color(0xFF323232),
                        colorText: const Color(0xFFFFFFFF),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F), // Hardcoded Primary Red
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

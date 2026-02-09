import 'package:flutter/material.dart';
import 'package:voicly_caller/features/dashboard/dashboard_screen.dart';
import 'package:voicly_caller/features/main/main_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../widget/app_button.dart';
import '../../widget/screen_wrapper.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      visibleAppBar: true,
      title: 'Complete Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Earnings Explanation Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.logoGradient.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primaryPeach.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Earning Rate",
                    style: TextStyle(
                      color: AppColors.primaryPeach,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoTile("10 Points", Icons.stars_rounded),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.compare_arrows_rounded,
                          color: Colors.white54,
                        ),
                      ),
                      _buildInfoTile(
                        "₹1 Rupee",
                        Icons.account_balance_wallet_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Earnings are calculated per second of talk time.",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- 2. Personal Details Section ---
            _buildSectionTitle("Personal Details"),
            const SizedBox(height: 16),
            _buildTextField(label: "Full Name", hint: "Enter your name"),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Age",
              hint: "e.g. 25",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            // --- 3. Payment Details Section ---
            _buildSectionTitle("Payment Setup (Withdrawals)"),
            const SizedBox(height: 16),
            _buildTextField(label: "UPI ID", hint: "yourname@okaxis"),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Bank Account Number",
              hint: "Enter A/C Number",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 40),

            // --- 4. Submit Button ---
            AppButton(
              text: "Save & Continue",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
                // Logic to save profile and go to Dashboard
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoTile(String text, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryLavender, size: 28),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

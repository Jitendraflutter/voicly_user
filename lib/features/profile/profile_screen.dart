import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widget/screen_wrapper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildProfileHeader(),
            const SizedBox(height: 40),
            _buildProfileOption(Icons.person_outline, "Edit Profile"),
            _buildProfileOption(Icons.account_balance_outlined, "Bank Details"),
            _buildProfileOption(Icons.security_outlined, "Privacy & Safety"),
            _buildProfileOption(Icons.help_outline, "Help Center"),
            const SizedBox(height: 20),
            _buildProfileOption(
              Icons.logout_rounded,
              "Logout",
              isDestructive: true,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.logoGradient,
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.dark,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryPeach,
              child: Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Aksbyte",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "ID: VOIC-99283",
          style: TextStyle(color: AppColors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.redAccent : AppColors.primaryLavender,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.redAccent : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.grey,
          size: 20,
        ),
      ),
    );
  }
}

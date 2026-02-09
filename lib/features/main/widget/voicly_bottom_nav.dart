import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class VoiclyBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VoiclyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled, 0),
          _navIcon(Icons.history_rounded, 1),
          _navIcon(Icons.account_balance_wallet_rounded, 2),
          _navIcon(Icons.person_rounded, 3),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isActive ? AppColors.primaryPeach : AppColors.grey.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widget/screen_wrapper.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({super.key});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          const Spacer(),

          // --- PULSING AVATAR ---
          Stack(
            alignment: Alignment.center,
            children: [
              _buildRipple(150.0),
              _buildRipple(200.0),
              _buildRipple(250.0),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.logoGradient,
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.dark,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            "Incoming Call",
            style: TextStyle(
              color: AppColors.primaryPeach,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "User_9928",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),

          const Spacer(),

          // --- ACTION BUTTONS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _callActionButton(
                  icon: Icons.close,
                  color: Colors.redAccent,
                  label: "Decline",
                  onTap: () => Navigator.pop(context),
                ),
                _callActionButton(
                  icon: Icons.call,
                  color: AppColors.primaryPurple,
                  label: "Accept",
                  onTap: () {
                    // Start Voice Call Logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(double size) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        return Container(
          width: size * _rippleController.value,
          height: size * _rippleController.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryPeach.withOpacity(
              1 - _rippleController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _callActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Icon(icon, color: color, size: 35),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

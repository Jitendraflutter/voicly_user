import 'package:flutter/material.dart';
import 'package:voicly_caller/features/caller/incoming_call_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../widget/screen_wrapper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOnline = false;


  @override
  void initState() {
    _incomingCall();
    super.initState();
  }

  void _incomingCall() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const IncomingCallScreen()),
        );
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: SingleChildScrollView(
        // Changed to ScrollView for content safety
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildEarningCard(),
            const SizedBox(height: 24),
            _buildStatusToggle(),
            const SizedBox(height: 24),
            _buildQuickStats(),
            const SizedBox(height: 120), // Bottom padding for the floating nav
          ],
        ),
      ),
    );
  }

  // --- TOP HEADER ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            Text(
              "Aksbyte",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.logoGradient,
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.dark,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // --- EARNINGS CARD (GLASS EFFECT) ---
  Widget _buildEarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            "TOTAL EARNINGS",
            style: TextStyle(
              color: AppColors.primaryPeach,
              letterSpacing: 1.5,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "₹ 1,245.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.stars,
                color: AppColors.primaryLavender,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                "12,450 Points",
                style: TextStyle(
                  color: AppColors.grey.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SMOOTH ONLINE/OFFLINE TOGGLE ---
  Widget _buildStatusToggle() {
    return GestureDetector(
      onTap: () => setState(() => isOnline = !isOnline),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isOnline
              ? AppColors.primaryPurple.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isOnline ? AppColors.primaryPurple : Colors.white10,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isOnline)
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryPeach),
                  ),
                Icon(
                  isOnline ? Icons.sensors : Icons.sensors_off,
                  color: isOnline ? AppColors.primaryPeach : AppColors.grey,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? "You are Online" : "You are Offline",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOnline ? "Ready to accept calls" : "Tap to start earning",
                  style: const TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            Switch.adaptive(
              value: isOnline,
              onChanged: (val) => setState(() => isOnline = val),
              activeColor: AppColors.primaryPeach,
            ),
          ],
        ),
      ),
    );
  }

  // --- QUICK STATS GRID ---
  Widget _buildQuickStats() {
    return Row(
      children: [
        _statItem("Calls", "24", Icons.call_received_rounded),
        const SizedBox(width: 16),
        _statItem("Minutes", "142m", Icons.timer_outlined),
      ],
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryLavender),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive
          ? AppColors.primaryPeach
          : AppColors.grey.withOpacity(0.5),
      size: 28,
    );
  }
}

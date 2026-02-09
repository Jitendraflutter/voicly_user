import 'package:flutter/material.dart';
import 'package:voicly_caller/features/history/history_screen.dart';
import 'package:voicly_caller/features/main/widget/voicly_bottom_nav.dart';
import 'package:voicly_caller/features/profile/profile_screen.dart';
import 'package:voicly_caller/features/wallet/wallet_screen.dart';
import '../dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const HistoryScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: VoiclyBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

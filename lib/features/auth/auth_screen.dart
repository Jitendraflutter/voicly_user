import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widget/app_button.dart';
import '../../widget/screen_wrapper.dart';
import '../setup/profile_setup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      // Keep AppBar hidden for a clean splash-like login look
      visibleAppBar: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // App Branding / Logo Section
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                gradient: AppColors.logoGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.waves_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Voicly Creator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Sign in to start accepting calls\n and earning points.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Google Auth Button
            // Using your AppButton for the primary action
            AppButton(
              text: "Continue with Google",
              onPressed: () {

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileSetupScreen(),));
                // Trigger Google Sign-In Logic
              },
            ),

            const SizedBox(height: 20),

            // Secondary Info
            const Text(
              "By signing in, you agree to our Privacy Policy",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

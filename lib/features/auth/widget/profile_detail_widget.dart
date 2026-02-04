import 'package:flutter/material.dart';
import 'auth_button.dart';
import 'base_auth_widget.dart';
import 'custom_text_field.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final VoidCallback onComplete;
  const ProfileDetailsScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: "About You",
      subtitle: "Help us get to know you better",
      child: Column(
        children: [
          customTextField(
            hint: "Full Name",
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),
          customTextField(
            hint: "Date of Birth",
            icon: Icons.cake_outlined,
            readOnly: true,
          ),
          const SizedBox(height: 40),
          gradientButton(text: "Complete Setup", onTap: onComplete),
        ],
      ),
    );
  }
}

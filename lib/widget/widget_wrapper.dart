import 'package:flutter/material.dart';

class WidgetWrapper extends StatelessWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: Stack(
        children: [
          // 🔥 Main gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B0220),
                  Color(0xFF14052E),
                  Color(0xFF000000),
                  Color(0xFF0B0C12),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.3, 0.5, 0.8, 1.0],
              ),
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.85, -0.95),
                radius: 0.9,
                colors: [
                  Color(0xFF1B063A),
                  Color(0xFF14052E),
                  Colors.transparent,
                ],
                stops: [0.0, 0.35, 1.0],
              ),
            ),
          ),

          // 🔥 Right radial glow
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.7, -0.9),
                radius: 0.8,
                colors: [Color(0xFF1B063A), Colors.transparent],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // 🔥 Content (no scaffold / no safearea)
          child,
        ],
      ),
    );
  }
}

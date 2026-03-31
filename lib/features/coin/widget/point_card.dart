import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 🟢 Added import
import 'package:marquee/marquee.dart';
import 'package:voicly/core/constant/app_assets.dart';

import '../model/point_pack_model.dart';

class EnhancedCoinCard extends StatelessWidget {
  final PointPackModel pack;
  final bool isSelected;
  final VoidCallback onTap;

  const EnhancedCoinCard({
    super.key,
    required this.pack,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r), // 🟢 Scaled
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLite
                : (pack.isPopular ? AppColors.green : Colors.white12),
            width: isSelected ? 2 : 1, // Kept absolute for crisp borders
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryLite.withValues(alpha: 0.2),
                    blurRadius: 15.r, // 🟢 Scaled
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r), // 🟢 Scaled
          child: Stack(
            children: [
              if (pack.discountPercent != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w, // 🟢 Scaled
                      vertical: 5.h, // 🟢 Scaled
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.r), // 🟢 Scaled
                      ),
                    ),
                    child: Text(
                      pack.discountPercent!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp, // 🟢 Scaled
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16.w), // 🟢 Scaled
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.vp,
                      width: 50.w, // 🟢 Scaled (.w on both to keep it square)
                      height: 50.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8.h), // 🟢 Scaled
                    Text(
                      "${pack.points}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp, // 🟢 Scaled
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pack.title,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp, // 🟢 Scaled
                      ),
                    ),

                    // SLIDING DESCRIPTION
                    SizedBox(height: 6.h), // 🟢 Scaled
                    SizedBox(
                      height: 18.h, // 🟢 Scaled
                      child: Marquee(
                        text: pack.description,
                        style: TextStyle(
                          color: AppColors.primaryLavender,
                          fontSize: 11.sp, // 🟢 Scaled
                        ),
                        velocity: 30.0,
                        blankSpace: 20.w, // 🟢 Scaled horizontal space
                        pauseAfterRound: const Duration(seconds: 2),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pack.originalPrice != null)
                          Text(
                            "₹${pack.originalPrice}",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12.sp, // 🟢 Scaled
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        SizedBox(width: 6.w), // 🟢 Scaled
                        Text(
                          "₹${pack.price}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp, // 🟢 Scaled
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

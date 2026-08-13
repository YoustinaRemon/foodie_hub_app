import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CircleBackground extends StatelessWidget {
  const CircleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -50,
      child: IgnorePointer(
        child: Container(
          width: 150.w,
          height: 150.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.circleBehindHerat.withValues(alpha: 0.18),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

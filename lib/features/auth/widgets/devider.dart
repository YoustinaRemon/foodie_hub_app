import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class CustomDevider extends StatelessWidget {
  const CustomDevider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.contentColor.withValues(alpha: 0.2),
            thickness: .6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR",
            style: TextStyle(color: AppColors.contentColor, fontSize: 14),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.contentColor.withValues(alpha: 0.2),
            thickness: 0.6,
          ),
        ),
      ],
    );
  }
}

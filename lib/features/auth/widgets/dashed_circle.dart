import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class DashedCircle extends StatelessWidget {
  const DashedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: OvalDottedBorderOptions(
        color: AppColors.borderColor,
        strokeWidth: 1.5,
        dashPattern: [5, 4],
      ),
      child: Container(
        width: 90,
        height: 90,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.mainColor,
        ),
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

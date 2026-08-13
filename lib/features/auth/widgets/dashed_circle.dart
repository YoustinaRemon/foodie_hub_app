import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        width: 90.w,
        height: 90.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.mainColor,
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.grey,
          size: 28.sp,
        ),
      ),
    );
  }
}

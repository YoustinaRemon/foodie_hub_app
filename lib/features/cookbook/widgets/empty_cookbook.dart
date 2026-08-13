import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EmptyCookbook extends StatelessWidget {
  const EmptyCookbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 80.sp,
            color: AppColors.borderColor.withValues(alpha: 0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            "Your Cookbook is Empty",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Save recipes you love and find them here later.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.contentColor,
                ),
          ),
        ],
      ),
    );
  }
}

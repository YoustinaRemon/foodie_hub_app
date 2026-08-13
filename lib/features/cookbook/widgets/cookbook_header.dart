import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CookbookHeader extends StatelessWidget {
  const CookbookHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 60, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cookbook",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.secondMainColor,
              fontWeight: FontWeight.w900,
              fontSize: 26.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Your personal collection of saved recipes.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.contentColor),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({
    super.key,
    this.message = 'No results found.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 54.sp,
            color: AppColors.borderColor,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.contentColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

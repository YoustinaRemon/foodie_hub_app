import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 54.sp,
              color: Colors.redAccent,
            ),
            SizedBox(height: 12.h),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.contentColor,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 150.w,
              child: AppButton(
                text: 'Retry',
                onTap: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

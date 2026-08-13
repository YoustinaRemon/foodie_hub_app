import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SmallButton extends StatelessWidget {
  final void Function()? onTap;
  const SmallButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: 116.w,
        decoration: BoxDecoration(
          color: AppColors.secondMainColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Start",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.mainColor),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward, color: AppColors.mainColor, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

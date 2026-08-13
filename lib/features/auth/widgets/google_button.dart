import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GoogleButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;

  const GoogleButton({super.key, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 360.w,
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icons.googleLogo, width: 22.w, height: 22.h),

            SizedBox(width: 10.w),

            Text(
              'Continue with Google',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

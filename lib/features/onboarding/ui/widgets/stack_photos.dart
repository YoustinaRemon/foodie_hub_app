import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackPhotos extends StatelessWidget {
  const StackPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300.w,
        height: 340.h,
        child: Stack(
          children: [
            Positioned(
              top: 15.h,
              right: 15.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Assets.images.stack1.image(
                  width: 225.w,
                  height: 225.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              bottom: 15.h,
              left: 15.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Assets.images.stack2.image(
                  width: 150.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 150.h,
              left: 130.w,
              child: Container(
                width: 60.w,
                height: 54.h,
                decoration: BoxDecoration(
                  color: AppColors.circleBehindHerat.withValues(alpha: .9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.heartColor,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

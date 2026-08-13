import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LabelOfTextField extends StatelessWidget {
  final String text;
  const LabelOfTextField({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 14.sp,
          color: AppColors.contentColor,
        ),
      ),
    );
  }
}

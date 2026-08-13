import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class AppTheme {
  static final ThemeData appTheme = ThemeData(
    fontFamily: "Literata",
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.mainColor,

    textTheme: TextTheme(
      //For big headlines
      headlineLarge: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),

      //For hints & buttons
      titleMedium: TextStyle(fontSize: 14.sp),
    ),
  );
}

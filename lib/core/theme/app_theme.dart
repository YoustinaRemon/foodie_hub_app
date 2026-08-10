import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    fontFamily: "Literata",
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.mainColor,

    textTheme: TextTheme(
      //For big headlines
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),

      //For hints & buttons
      titleMedium: TextStyle(fontSize: 16),
    ),
  );
}

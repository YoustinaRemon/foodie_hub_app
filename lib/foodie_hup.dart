import 'package:flutter/material.dart';
import 'package:foodie_hup/core/theme/app_theme.dart';
import 'package:foodie_hup/features/onboarding/ui/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Hup',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.appTheme,
      home: OnboardingScreen(),
    );
  }
}

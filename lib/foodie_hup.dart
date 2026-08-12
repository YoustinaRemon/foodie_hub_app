import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/theme/app_theme.dart';
import 'package:foodie_hup/features/onboarding/ui/onboarding_screen.dart';
import 'package:foodie_hup/features/landing_page/ui/landing_screen.dart';
import 'package:foodie_hup/features/main/ui/main_layout.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:foodie_hup/core/utils/navigator_key.dart';

class FoodieHup extends StatelessWidget {
  final bool onboardingCompleted;
  const FoodieHup({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Foodie Hup',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.currentUser != null) {
            return const MainLayout();
          }
          return onboardingCompleted ? const LandingScreen() : const OnboardingScreen();
        },
      ),
    );
  }
}

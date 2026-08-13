import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:foodie_hup/core/theme/app_theme.dart';
import 'package:foodie_hup/features/onboarding/ui/onboarding_screen.dart';
import 'package:foodie_hup/features/landing_page/ui/landing_screen.dart';
import 'package:foodie_hup/features/main/ui/main_layout.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:foodie_hup/core/utils/navigator_key.dart';

class FoodieHup extends StatefulWidget {
  final bool onboardingCompleted;
  const FoodieHup({super.key, required this.onboardingCompleted});

  static FoodieHupState? of(BuildContext context) =>
      context.findAncestorStateOfType<FoodieHupState>();

  @override
  State<FoodieHup> createState() => FoodieHupState();
}

class FoodieHupState extends State<FoodieHup> {
  late bool _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _onboardingCompleted = widget.onboardingCompleted;
  }

  void completeOnboarding() {
    setState(() {
      _onboardingCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
              return _onboardingCompleted
                  ? const LandingScreen()
                  : const OnboardingScreen();
            },
          ),
        );
      },
    );
  }
}

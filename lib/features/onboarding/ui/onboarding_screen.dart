import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/onboarding/ui/widgets/small_button.dart';
import 'package:foodie_hup/features/onboarding/ui/widgets/stack_photos.dart';
import 'package:foodie_hup/foodie_hup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StackPhotos(),
              SizedBox(height: 32.h),
              Text(
                "Save Your\nFavorites",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 30.sp,
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Build your personal cookbook. Keep track of the meals you love and organize them for easy access anytime.",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.contentColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: SmallButton(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboardingCompleted', true);
                    if (context.mounted) {
                      FoodieHup.of(context)?.completeOnboarding();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

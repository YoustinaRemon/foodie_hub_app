import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/features/landing/ui/landing_screen.dart';
import 'package:foodie_hup/features/onboarding/ui/widgets/small_button.dart';
import 'package:foodie_hup/features/onboarding/ui/widgets/stack_photos.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StackPhotos(),
              SizedBox(height: 42),
              Text(
                "Save Your\nFavorites",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 36,
                  color: AppColors.secondMainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Build your personal cookbook. Keep track of the meals you love and organize them for easy access anytime.",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  color: AppColors.contentColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: SmallButton(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LandingScreen()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

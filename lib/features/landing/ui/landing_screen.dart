import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/features/auth/ui/login_screen.dart';
import 'package:foodie_hup/features/auth/ui/register_screen.dart';
import 'package:foodie_hup/gen/assets.gen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.landingPageBackground.image().image,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: .4),
                BlendMode.lighten,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Image(image: Assets.images.logo.image().image),
                SizedBox(height: 300),
                Text(
                  "Welcome to FoodieHub",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 36,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Your personal guide to discovering and creating delicious recipes.",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                AppButton(
                  text: "Login",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  color: AppColors.secondMainColor.withValues(alpha: .9),
                ),
                SizedBox(height: 15),
                AppButton(
                  text: "Register",
                  color: AppColors.mainColor.withValues(alpha: .9),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.secondMainColor,
                    fontSize: 18,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

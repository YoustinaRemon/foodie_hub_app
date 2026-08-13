import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/features/auth/ui/login_screen.dart';
import 'package:foodie_hup/features/auth/ui/register_screen.dart';
import 'package:foodie_hup/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: EdgeInsets.all(24.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Image(image: Assets.images.logo.image().image),
                SizedBox(height: 240.h),
                Text(
                  "Welcome to FoodieHub",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 30.sp,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Your personal guide to discovering and creating delicious recipes.",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                AppButton(
                  text: "Login",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  color: AppColors.secondMainColor.withValues(alpha: .9),
                ),
                SizedBox(height: 12.h),
                AppButton(
                  text: "Register",
                  color: AppColors.mainColor.withValues(alpha: .9),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.secondMainColor,
                    fontSize: 16.sp,
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

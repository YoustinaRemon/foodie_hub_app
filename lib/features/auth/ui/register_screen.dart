import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/core/widgets/custom_text_field.dart';
import 'package:foodie_hup/core/widgets/devider.dart';
import 'package:foodie_hup/core/widgets/label_of_text_field.dart';
import 'package:foodie_hup/features/auth/ui/widgets/circle_background.dart';
import 'package:foodie_hup/features/auth/ui/widgets/dashed_circle.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Card(
                elevation: 2,
                shadowColor: AppColors.mainColor,
                color: Colors.white,
                child: Stack(
                  children: [
                    CircleBackground(),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Join FoodieHub to discover your next\nfavorite recipe.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: AppColors.contentColor),
                            ),
                            SizedBox(height: 35),
                            DashedCircle(),
                            SizedBox(height: 8),
                            Text(
                              "Upload photo",
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    color: AppColors.contentColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            SizedBox(height: 30),
                            LabelOfTextField(text: "Full Name"),
                            SizedBox(height: 5),
                            CustomTextField(
                              text: "Enter your full name",
                              prefixIcon: Icon(Icons.person_2_outlined),
                            ),
                            SizedBox(height: 24),
                            LabelOfTextField(text: "Email"),
                            SizedBox(height: 5),
                            CustomTextField(
                              text: "Enter your Email",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            SizedBox(height: 24),
                            LabelOfTextField(text: "Password"),
                            SizedBox(height: 5),
                            CustomTextField(
                              text: "Create your Password",
                              isPassword: true,
                              prefixIcon: Icon(Icons.lock_outlined),
                            ),
                            SizedBox(height: 24),
                            LabelOfTextField(text: "Confirm Password"),
                            SizedBox(height: 5),
                            CustomTextField(
                              text: "Confirm your Password",
                              isPassword: true,
                              prefixIcon: Icon(
                                Icons.replay_circle_filled_sharp,
                              ),
                            ),
                            SizedBox(height: 60),
                            AppButton(text: "Create Your Account"),
                            SizedBox(height: 30),
                            Devider(),
                            SizedBox(height: 30),
                            AppButton(
                              border: BoxBorder.all(
                                color: AppColors.borderColor,
                              ),
                              text: "Continue With Google",
                              color: AppColors.mainColor,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium!.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

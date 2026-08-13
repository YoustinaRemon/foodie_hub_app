import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/core/widgets/back_arrow.dart';
import 'package:foodie_hup/core/widgets/custom_text_field.dart';
import 'package:foodie_hup/features/auth/widgets/devider.dart';
import 'package:foodie_hup/features/auth/widgets/google_button.dart';
import 'package:foodie_hup/core/widgets/label_of_text_field.dart';
import 'package:foodie_hup/features/auth/widgets/circle_background.dart';
import 'package:foodie_hup/features/auth/widgets/dashed_circle.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';

import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required' : null;
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError = _passwordController.text.isEmpty ? 'Password is required' : null;
      _confirmPasswordError = _confirmPasswordController.text != _passwordController.text 
          ? 'Passwords do not match' 
          : null;
    });

    if (_nameError == null && _emailError == null && _passwordError == null && _confirmPasswordError == null) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      if (success && mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Registration failed')),
        );
      }
    }
  }

  void _loginWithGoogle() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithGoogle();
    if (success && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (!success && mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Card(
                elevation: 2,
                shadowColor: AppColors.mainColor,
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: BackArrow(),
                    ),
                    CircleBackground(),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Join FoodieHub to discover your next\nfavorite recipe.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: AppColors.contentColor),
                            ),
                            SizedBox(height: 24.h),
                            DashedCircle(),
                            SizedBox(height: 8.h),
                            Text(
                              "Upload photo",
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    color: AppColors.contentColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            SizedBox(height: 20.h),
                            LabelOfTextField(text: "Full Name"),
                            SizedBox(height: 4.h),
                            CustomTextField(
                              controller: _nameController,
                              errorText: _nameError,
                              text: "Enter your full name",
                              prefixIcon: Icon(Icons.person_2_outlined),
                            ),
                            SizedBox(height: 16.h),
                            LabelOfTextField(text: "Email"),
                            SizedBox(height: 4.h),
                            CustomTextField(
                              controller: _emailController,
                              errorText: _emailError,
                              text: "Enter your Email",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            SizedBox(height: 16.h),
                            LabelOfTextField(text: "Password"),
                            SizedBox(height: 4.h),
                            CustomTextField(
                              controller: _passwordController,
                              errorText: _passwordError,
                              text: "Create your Password",
                              isPassword: true,
                              prefixIcon: Icon(Icons.lock_outlined),
                            ),
                            SizedBox(height: 16.h),
                            LabelOfTextField(text: "Confirm Password"),
                            SizedBox(height: 4.h),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              errorText: _confirmPasswordError,
                              text: "Confirm your Password",
                              isPassword: true,
                              prefixIcon: Icon(
                                Icons.replay_circle_filled_sharp,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            isLoading
                                ? Center(child: LoadingWidget())
                                : AppButton(
                                    text: "Create Your Account",
                                    onTap: _register,
                                  ),
                            SizedBox(height: 20.h),
                            CustomDevider(),
                            SizedBox(height: 20.h),
                            isLoading
                                ? SizedBox.shrink()
                                : GoogleButton(
                                    onTap: _loginWithGoogle,
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

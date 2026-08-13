import 'package:flutter/material.dart';
import 'package:foodie_hup/core/constants/app_colors.dart';
import 'package:foodie_hup/core/widgets/app_button.dart';
import 'package:foodie_hup/core/widgets/back_arrow.dart';
import 'package:foodie_hup/core/widgets/custom_text_field.dart';
import 'package:foodie_hup/features/auth/widgets/devider.dart';
import 'package:foodie_hup/features/auth/widgets/google_button.dart';
import 'package:foodie_hup/gen/assets.gen.dart';
import 'package:foodie_hup/core/widgets/loading_widget.dart';

import 'package:provider/provider.dart';
import 'package:foodie_hup/features/auth/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError = _passwordController.text.isEmpty ? 'Password is required' : null;
    });

    if (_emailError == null && _passwordError == null) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed')),
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
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    SizedBox(
                      height: 170.h,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 45.h,
                            left: 0.w,
                            right: 0.w,
                            bottom: 0.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              child: Image.asset(
                                Assets.images.loginCover.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0.w,
                            right: 0.w,
                            bottom: 0.h,
                            height: 80.h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0x99FFFFFF),
                                    Colors.white,
                                  ],
                                  stops: [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),

                          Positioned(top: 8.h, left: 8.w, child: BackArrow()),
                          Positioned(
                            left: 0.w,
                            right: 0.w,
                            bottom: 0.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondMainColor,
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    color: AppColors.mainColor,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'FoodieHub',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Sign in to discover your next favorite recipe.',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.contentColor),
                          ),

                          SizedBox(height: 24.h),
                          CustomTextField(
                            controller: _emailController,
                            errorText: _emailError,
                            text: 'Enter your Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),

                          SizedBox(height: 16.h),

                          CustomTextField(
                            controller: _passwordController,
                            errorText: _passwordError,
                            text: 'Enter your Password',
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock_outlined),
                          ),

                          SizedBox(height: 32.h),
                          isLoading
                              ? Center(child: LoadingWidget())
                              : AppButton(
                                  text: 'Login',
                                  onTap: _login,
                                ),
                          SizedBox(height: 16.h),
                          CustomDevider(),
                          SizedBox(height: 16.h),
                          isLoading
                              ? SizedBox.shrink()
                              : GoogleButton(
                                  onTap: _loginWithGoogle,
                                ),
                        ],
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

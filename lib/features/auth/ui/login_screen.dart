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
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Card(
                elevation: 2,
                shadowColor: AppColors.mainColor,
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    SizedBox(
                      height: 190,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 55,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: Image.asset(
                                Assets.images.loginCover.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 90,
                            child: Container(
                              decoration: const BoxDecoration(
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

                          Positioned(top: 8, left: 8, child: BackArrow()),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondMainColor,
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    color: AppColors.mainColor,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 10),
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
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Sign in to discover your next favorite recipe.',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.contentColor),
                          ),

                          const SizedBox(height: 30),
                          CustomTextField(
                            controller: _emailController,
                            errorText: _emailError,
                            text: 'Enter your Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),

                          SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            errorText: _passwordError,
                            text: 'Enter your Password',
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock_outlined),
                          ),

                          SizedBox(height: 40),
                          isLoading
                              ? const Center(child: LoadingWidget())
                              : AppButton(
                                  text: 'Login',
                                  onTap: _login,
                                ),
                          SizedBox(height: 20),
                          CustomDevider(),
                          SizedBox(height: 20),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/widgets/custom_button.dart';
import 'package:kkuk_kkuk/theme/app_colors.dart';
import 'package:kkuk_kkuk/theme/app_text_styles.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({super.key});

  void _handleSignIn(BuildContext context) {
    context.go('/login');
  }

  void _handleSignUp(BuildContext context) {
    // TODO: 회원가입 기능 구현 예정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text('꾹꾹', style: AppTextStyles.headline2),
              const Spacer(),
              CustomButton(
                text: '로그인',
                onPressed: () => _handleSignIn(context),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: '회원가입',
                onPressed: () => _handleSignUp(context),
                backgroundColor: AppColors.primary,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

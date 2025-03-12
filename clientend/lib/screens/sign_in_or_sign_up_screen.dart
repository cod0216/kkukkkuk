import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({super.key});

  void _handleSignIn(BuildContext context) {
    // TODO: 로그인 기능 구현 예정
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

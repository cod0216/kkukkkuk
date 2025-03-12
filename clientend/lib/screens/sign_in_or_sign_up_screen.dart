import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({super.key});

  void _handleSignIn(BuildContext context) {
    // 로그인 기능 구현 예정
  }

  void _handleSignUp(BuildContext context) {
    // 회원가입 기능 구현 예정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                '꾹꾹',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              CustomButton(
                text: '로그인',
                onPressed: () => _handleSignIn(context),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: '회원가입',
                onPressed: () => _handleSignUp(context),
                backgroundColor: const Color(0xFF8BC34A), // Light green color
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/widgets/common/app_logo.dart';

class LoginWelcomeSection extends StatelessWidget {
  final double screenHeight;
  final double fontSize;

  const LoginWelcomeSection({
    super.key,
    required this.screenHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(label: '꾹꾹 앱 로고', child: AppLogo()),
        SizedBox(height: screenHeight * 0.05),
        Semantics(
          label: '환영 메시지',
          child: const Text(
            '환영합니다',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Semantics(
          label: '로그인 안내 메시지',
          child: Text(
            '카카오 계정으로 로그인하여 서비스를 이용해보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

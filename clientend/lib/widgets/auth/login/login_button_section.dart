import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/widgets/auth/kakao_login_button.dart';

class LoginButtonSection extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final bool isLoading;
  final double bottomPadding;

  const LoginButtonSection({
    super.key,
    required this.onLoginPressed,
    required this.isLoading,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: '카카오 로그인 버튼',
          button: true,
          enabled: !isLoading,
          child: ExcludeSemantics(
            child: KakaoLoginButton(
              onPressed: onLoginPressed,
              isLoading: isLoading,
            ),
          ),
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }
}

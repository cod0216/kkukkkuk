import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/kakao_login_button.dart';
import 'package:kkuk_kkuk/screens/common/widgets/app_logo.dart';

/// 로그인 화면
class LoginView extends ConsumerWidget {
  final AuthController controller;

  // TODO: 로그인 실패 시 재시도 기능 추가
  // TODO: 로딩 상태 애니메이션 개선

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 로그인 상태 관리
    final loginState = ref.watch(loginProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 여백
            const Spacer(flex: 2),

            // 앱 로고
            AppLogo(),

            // 로고와 버튼 사이 여백
            const Spacer(flex: 2),

            // 카카오 로그인 버튼
            KakaoLoginButton(
              onPressed: () => controller.handleLogin(),
              isLoading: loginState.isLoading,
            ),

            // 하단 여백
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

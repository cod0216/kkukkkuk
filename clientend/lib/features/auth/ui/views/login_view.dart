import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/auth/ui/widgets/kakao_login_button.dart';
import 'package:kkuk_kkuk/widgets/app_logo.dart';
import 'package:kkuk_kkuk/features/auth/model/providers/auth_view_model.dart';

/// 로그인 화면
class LoginView extends ConsumerWidget {
  final AuthViewModel controller;

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            const AppLogo(),
            const SizedBox(height: 40),
            KakaoLoginButton(
              onPressed: () => controller.handleLogin(),
              isLoading: authState.isLoginLoading,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

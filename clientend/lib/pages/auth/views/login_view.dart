import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/widgets/auth/kakao_login_button.dart';
import 'package:kkuk_kkuk/widgets/common/logo/app_logo.dart';
import 'package:kkuk_kkuk/pages/auth/notifiers/auth_notifier.dart';

/// 로그인 화면
class LoginView extends ConsumerWidget {
  final AuthNotifier viewModel;

  const LoginView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

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
              onPressed: () => viewModel.handleLogin(),
              isLoading: authState.isLoginLoading,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

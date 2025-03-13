import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/login/login_button_section.dart';
import 'package:kkuk_kkuk/screens/common/widgets/app_logo.dart';

class LoginView extends ConsumerWidget {
  final AuthController controller;

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Semantics(label: '꾹꾹 앱 로고', child: AppLogo())],
              ),
            ),
            LoginButtonSection(
              onLoginPressed: () => controller.handleLogin(),
              isLoading: loginState.isLoading,
              bottomPadding: size.height * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}

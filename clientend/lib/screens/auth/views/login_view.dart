import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_app_bar.dart';
import 'package:kkuk_kkuk/widgets/auth/login/login_welcome_section.dart';
import 'package:kkuk_kkuk/widgets/auth/login/login_button_section.dart';

class LoginView extends ConsumerWidget {
  final AuthController controller;

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AuthAppBar(title: '로그인'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginWelcomeSection(
                      screenHeight: size.height,
                      fontSize: size.width * 0.04,
                    ),
                    if (loginState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          loginState.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
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
      ),
    );
  }
}

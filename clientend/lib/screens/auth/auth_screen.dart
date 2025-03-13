import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/controllers/auth/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/screens/auth/views/login_view.dart';
import 'package:kkuk_kkuk/screens/auth/views/wallet_setup_view.dart';
import 'package:kkuk_kkuk/screens/common/widgets/loading_indicator.dart';
import 'package:kkuk_kkuk/screens/common/widgets/error_view.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStep = ref.watch(authCoordinatorProvider);
    final controller = ref.watch(authControllerProvider);

    if (authStep == AuthStep.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('꾹꾹 로그인인')),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(authStep, controller),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AuthStep step, AuthController controller) {
    switch (step) {
      case AuthStep.initial:
        return const LoadingIndicator();
      case AuthStep.login:
        return LoginView(controller: controller);
      case AuthStep.walletSetup:
        return WalletSetupView(controller: controller);
      case AuthStep.completed:
        return const LoadingIndicator();
      case AuthStep.error:
        return ErrorView(
          message: '오류가 발생했습니다.',
          onRetry: () => controller.resetAuthFlow(),
        );
    }
  }
}

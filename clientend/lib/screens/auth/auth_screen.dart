import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/screens/auth/views/login_view.dart';
import 'package:kkuk_kkuk/screens/auth/views/wallet_setup_view.dart';
import 'package:kkuk_kkuk/screens/common/widgets/loading_indicator.dart';
import 'package:kkuk_kkuk/screens/common/error_view.dart';

/// 인증 화면
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // TODO: 자동 로그인 기능 구현
  // TODO: 생체 인증 기능 추가
  // TODO: 소셜 로그인 추가 옵션 구현
  // TODO: 로그인 히스토리 관리 기능
  // TODO: 디바이스 인증 정보 관리

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  /// 인증 초기화 함수
  void _initializeAuth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStep = ref.watch(authCoordinatorProvider);
    final controller = ref.watch(authControllerProvider);

    // 인증 완료시 홈 화면으로 이동
    if (authStep == AuthStep.completed) {
      _navigateToHome(context);
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(authStep, controller),
        ),
      ),
    );
  }

  /// 앱바 구성
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('auth screen app bar'));
  }

  /// 홈 화면 이동 처리
  void _navigateToHome(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/home');
    });
  }

  /// 현재 인증 단계에 따른 화면 구성
  Widget _buildCurrentStep(AuthStep step, AuthController controller) {
    switch (step) {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';
import 'package:kkuk_kkuk/screens/auth/views/login_view.dart';
import 'package:kkuk_kkuk/screens/auth/views/network_connection_view.dart';
import 'package:kkuk_kkuk/screens/wallet/wallet_screen.dart';
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
      ref.read(authControllerProvider.notifier).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStep = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final mnemonicState = ref.watch(mnemonicWalletProvider);

    // 인증 완료시 홈 화면으로 이동
    if (authStep == AuthStep.completed) {
      _navigateToHome(context);
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: _buildAppBar(authStep),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(authStep, controller, mnemonicState),
        ),
      ),
    );
  }

  /// 앱바 구성
  PreferredSizeWidget _buildAppBar(AuthStep step) {
    String title;

    switch (step) {
      case AuthStep.login:
        title = '로그인';
        break;
      case AuthStep.walletSetup:
        title = '지갑 설정';
        break;
      case AuthStep.networkConnection:
        title = '네트워크 연결';
        break;
      case AuthStep.completed:
        title = '인증 완료';
        break;
      case AuthStep.error:
        title = '오류';
        break;
    }

    return AppBar(title: Text(title));
  }

  /// 홈 화면 이동 처리
  void _navigateToHome(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/home');
    });
  }

  /// 현재 인증 단계에 따른 화면 구성
  Widget _buildCurrentStep(
    AuthStep step,
    AuthController controller,
    MnemonicWalletState mnemonicState,
  ) {
    switch (step) {
      case AuthStep.login:
        return LoginView(controller: controller);

      case AuthStep.walletSetup:
        // 통합된 지갑 화면 사용
        return WalletScreen(controller: controller);

      case AuthStep.networkConnection:
        return NetworkConnectionView(controller: controller);

      case AuthStep.error:
        return ErrorView(
          message: '인증 중 오류가 발생했습니다.',
          onRetry: () => controller.handleErrorRetry(),
        );

      case AuthStep.completed:
        return const Center(child: Text('인증이 완료되었습니다.'));
    }
  }
}

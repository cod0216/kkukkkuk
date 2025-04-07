import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/features/auth/model/states/auth_state.dart';
import 'package:kkuk_kkuk/features/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/features/auth/ui/views/login_view.dart';
import 'package:kkuk_kkuk/features/auth/ui/views/network_connection_view.dart';
import 'package:kkuk_kkuk/features/auth/ui/views/wallet_guide_view.dart';
import 'package:kkuk_kkuk/shared/ui/widgets/loading_indicator.dart';
import 'package:kkuk_kkuk/shared/ui/widgets/error_view.dart';
import 'package:kkuk_kkuk/features/auth/model/notifiers/auth_notifier.dart';

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
      ref.read(authNotifierProvider.notifier).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final viewModel = ref.read(authNotifierProvider.notifier);
    final mnemonicState = ref.watch(walletNotifierProvider);

    // 인증 완료시 홈 화면으로 이동
    if (authState.currentStep == AuthStep.completed) {
      _navigateToHome(context);
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: _buildAppBar(authState.currentStep),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(
            authState.currentStep,
            viewModel,
            mnemonicState,
          ),
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
        title = '지갑 안내';
        break;
      case AuthStep.walletCreation:
        title = '지갑 생성';
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
    AuthNotifier viewModel,
    WalletState mnemonicState,
  ) {
    switch (step) {
      case AuthStep.login:
        return LoginView(viewModel: viewModel);

      case AuthStep.walletSetup:
      case AuthStep.walletCreation:
        return WalletGuideView(viewModel: viewModel);

      case AuthStep.networkConnection:
        return NetworkConnectionView(viewModel: viewModel);

      case AuthStep.error:
        return ErrorView(
          message: '인증 중 오류가 발생했습니다.',
          onRetry: () => viewModel.handleErrorRetry(),
        );

      case AuthStep.completed:
        return const Center(child: Text('인증이 완료되었습니다.'));
    }
  }
}

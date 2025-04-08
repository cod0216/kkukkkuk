import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/auth/states/auth_state.dart';
import 'package:kkuk_kkuk/pages/auth/views/login_view.dart';
import 'package:kkuk_kkuk/pages/auth/views/wallet_guide_view.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/error_view.dart';
import 'package:kkuk_kkuk/pages/auth/notifiers/auth_notifier.dart';

/// 인증 화면
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final viewModel = ref.read(authNotifierProvider.notifier);

    // 인증 완료시 홈 화면으로 이동
    if (authState.currentStep == AuthStep.completed) {
      _navigateToHome(context);
      // 완료 상태에서는 로딩 인디케이터보다는 빈 화면이나 간단한 메시지가 나을 수 있습니다.
      return const Scaffold(body: Center(child: Text("인증 완료. 홈으로 이동합니다...")));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // 현재 스텝에 맞는 뷰 표시
          child: _buildCurrentStep(
            authState.currentStep,
            viewModel,
            // mnemonicState, // 파라미터 제거
          ),
        ),
      ),
    );
  }

  /// 홈 화면 이동 처리
  void _navigateToHome(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // GoRouter의 context.go는 비동기 작업 후 호출 시 안전합니다.
      if (mounted) {
        // 위젯이 여전히 마운트 상태인지 확인
        print("Navigating to /home");
        context.go('/home');
      }
    });
  }

  /// 현재 인증 단계에 따른 화면 구성
  Widget _buildCurrentStep(
    AuthStep step,
    AuthNotifier viewModel,
    // WalletState mnemonicState, // 파라미터 제거
  ) {
    // 각 단계에 맞는 위젯 반환
    // key를 사용하여 AnimatedSwitcher가 위젯 변경을 감지하도록 함
    switch (step) {
      case AuthStep.login:
        // LoginView가 authState를 watch하여 에러 메시지 등을 표시하도록 구현할 수 있음
        return LoginView(
          key: const ValueKey('LoginView'),
          viewModel: viewModel,
        );

      case AuthStep.walletSetup:
        // walletCreation 단계는 별도 라우트로 이동하므로 walletSetup만 처리
        return WalletGuideView(
          key: const ValueKey('WalletGuideView'),
          viewModel: viewModel,
        );
      case AuthStep.error:
        // AuthNotifier의 에러 상태를 사용하여 메시지 표시
        final authState = ref.read(authNotifierProvider);
        return ErrorView(
          key: const ValueKey('ErrorView'),
          message: authState.loginError ?? '알 수 없는 오류가 발생했습니다.',
          onRetry: () => viewModel.handleErrorRetry(), // 로그인 단계로 돌아감
        );

      case AuthStep.completed: // 이 케이스는 build 메서드 시작 부분에서 처리됨
        return const SizedBox.shrink(
          key: ValueKey('CompletedEmpty'),
        ); // 이론상 도달하지 않음

      case AuthStep.walletCreation: // 이 단계는 별도 라우트(/wallet-creation)에서 처리됨
        print(
          "AuthScreen Warning: AuthStep.walletCreation reached, should be handled by router.",
        );
        // 혹시 모를 경우 로그인 화면으로 돌려보내거나 에러 처리
        return LoginView(
          key: const ValueKey('LoginView_Fallback'),
          viewModel: viewModel,
        );

      default: // 정의되지 않은 상태일 경우 로그인 화면으로
        print(
          "AuthScreen Warning: Unknown AuthStep $step, returning to LoginView.",
        );
        return LoginView(
          key: const ValueKey('LoginView_Default'),
          viewModel: viewModel,
        );
    }
  }
}

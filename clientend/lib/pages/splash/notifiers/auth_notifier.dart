// lib/pages/auth/notifiers/auth_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/splash/states/auth_state.dart';
import 'package:kkuk_kkuk/features/auth/usecases/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/features/auth/usecases/oauth/oauth_usecase_providers.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';

/// 로그인 결과를 담는 클래스
class AuthResult {
  final bool success;
  final bool hasWallet;
  final String? error;

  AuthResult({required this.success, this.hasWallet = false, this.error});
}

/// 인증 관련 비즈니스 로직을 처리하는 뷰 모델
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final _secureStorage = const FlutterSecureStorage();
  static const String _privateKeyKey = 'eth_private_key';

  AuthNotifier(this.ref) : super(AuthState());

  /// 인증 초기화
  void initializeAuth() {
    state = state.copyWith(currentStep: AuthStep.login);
  }

  /// 로그인 처리
  Future<AuthResult> signInWithKakao() async {
    try {
      state = state.copyWith(isLoginLoading: true, loginError: null);
      final kakaoLoginUseCase = ref.read(kakaoLoginUseCaseProvider);
      final userInfo = await kakaoLoginUseCase.execute();
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase.execute(userInfo);

      state = state.copyWith(isLoginLoading: false, user: user);

      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final hasWallet = privateKey != null && privateKey.isNotEmpty;

      print("Login successful. User has wallet: $hasWallet");
      return AuthResult(success: true, hasWallet: hasWallet);
    } catch (e) {
      print('로그인 실패: $e');
      state = state.copyWith(isLoginLoading: false, loginError: '로그인 실패: $e');
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<AuthResult> handleLogin() async {
    // *** 반환 타입을 Future<AuthResult>로 명시 ***
    try {
      state = state.copyWith(isLoginLoading: true); // 로딩 상태 시작
      final result = await signInWithKakao();

      if (!result.success) {
        // 로그인 실패 시 에러 상태 설정 및 결과 반환
        state = state.copyWith(
          currentStep: AuthStep.login, // 로그인 단계 유지
          loginError: result.error ?? '로그인에 실패했습니다.',
          isLoginLoading: false,
        );
        return result; // 실패 결과 반환
      }

      // 로그인 성공 시
      if (result.hasWallet) {
        // 지갑 있으면 완료 상태로
        print("Wallet exists, completing authentication.");
        // completeAuth(); // 상태 변경만 하고 라우팅은 호출부(SplashScreen)에서 처리
        state = state.copyWith(
          currentStep: AuthStep.completed,
          isLoginLoading: false,
        );
      } else {
        // 지갑 없으면 설정 단계로 (상태 변경만)
        print("Wallet does not exist, moving to wallet setup internally.");
        ref.read(walletNotifierProvider.notifier).reset();
        // moveToWalletSetup(); // 상태 변경만 하고 라우팅은 호출부(SplashScreen)에서 처리
        state = state.copyWith(
          currentStep: AuthStep.walletSetup,
          isLoginLoading: false,
        );
      }
      return result; // 성공 결과 반환
    } catch (e) {
      // 예외 발생 시 에러 상태 설정 및 실패 결과 반환
      state = state.copyWith(
        currentStep: AuthStep.login,
        loginError: '로그인 처리 중 오류: ${e.toString()}',
        isLoginLoading: false,
      );
      return AuthResult(success: false, error: e.toString()); // 실패 결과 반환
    } finally {
      // 로딩 상태 종료 (필요시)
      // if (state.isLoginLoading) {
      //   state = state.copyWith(isLoginLoading: false);
      // }
    }
  }

  /// 지갑 설정 안내 화면으로 이동 (상태 변경 로직은 handleLogin 내부에 통합됨)
  // void moveToWalletSetup() {
  //   state = state.copyWith(currentStep: AuthStep.walletSetup);
  // }

  /// 지갑 생성 화면으로 이동 (별도 라우트 사용)
  void moveToWalletCreation(BuildContext context) {
    ref.read(walletNotifierProvider.notifier).reset();
    if (context.mounted) {
      context.push('/wallet-creation', extra: walletNotifierProvider);
    }
  }

  /// 인증 완료 처리 (상태 변경 로직은 handleLogin 내부에 통합됨)
  // void completeAuth() {
  //   print("Authentication completed. Setting state to AuthStep.completed.");
  //   state = state.copyWith(currentStep: AuthStep.completed);
  // }

  /// 에러 발생 시 처리 (로그인 단계로 돌아가도록 수정)
  void handleErrorRetry() {
    print("Handling error retry. Returning to login step.");
    initializeAuth();
    ref.read(walletNotifierProvider.notifier).reset();
  }

  /// 인증 흐름 및 관련 상태 초기화
  void reset() {
    print("Resetting AuthNotifier state.");
    ref.read(walletNotifierProvider.notifier).reset();
    state = AuthState();
  }
}

/// 인증 뷰 모델 프로바이더
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref);
});

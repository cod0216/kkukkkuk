// lib/pages/auth/notifiers/auth_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/auth/states/auth_state.dart';
import 'package:kkuk_kkuk/features/auth/usecases/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/features/auth/usecases/oauth/oauth_usecase_providers.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
// import 'package:kkuk_kkuk/shared/blockchain/client/blockchain_client.dart'; // BlockchainClient import 제거 또는 주석 처리

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
    // 앱 시작 시 초기 상태를 login으로 설정
    state = state.copyWith(currentStep: AuthStep.login);
  }

  /// 로그인 처리
  Future<AuthResult> signInWithKakao() async {
    try {
      state = state.copyWith(isLoginLoading: true, loginError: null);
      // 카카오 로그인
      final kakaoLoginUseCase = ref.read(kakaoLoginUseCaseProvider);
      final userInfo = await kakaoLoginUseCase.execute();
      // 카카오 로그인 성공 시 서버 로그인 처리
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase.execute(userInfo);

      // 사용자 정보 저장
      state = state.copyWith(isLoginLoading: false, user: user);

      // 로컬 스토리지에 개인키 저장 확인 (지갑 존재 여부 판단)
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

  /* --- 블록체인 네트워크 연결 메서드 (제거 또는 주석 처리) ---
  // Future<bool> connectToNetwork() async {
  //   // 스플래시 화면에서 처리하므로 이 메서드는 사용하지 않음
  //   print("connectToNetwork is now handled in SplashScreen.");
  //   state = state.copyWith(networkStatus: NetworkConnectionStatus.connected);
  //   return true; // 스플래시에서 연결되었다고 가정
  // }
  */

  /// 로그인 처리 핸들러
  Future<void> handleLogin() async {
    try {
      final result = await signInWithKakao();

      if (!result.success) {
        // 로그인 실패 시 로그인 화면에 머무르며 에러 메시지 표시 (상태 업데이트는 signInWithKakao에서 처리)
        return;
      }

      // 로그인 성공 후
      if (result.hasWallet) {
        // 지갑이 있으면 바로 인증 완료 단계로 이동 (네트워크 연결은 스플래시에서 완료됨)
        print("Wallet exists, completing authentication.");
        completeAuth(); // AuthStep.completed로 변경하고 홈으로 이동 트리거
      } else {
        // 지갑이 없으면 지갑 설정 단계로 이동
        print("Wallet does not exist, moving to wallet setup.");
        ref.read(walletNotifierProvider.notifier).reset();
        moveToWalletSetup();
      }
    } catch (e) {
      // 예외 발생 시 로그인 화면에 머무르며 에러 상태 설정
      state = state.copyWith(
        currentStep: AuthStep.login,
        loginError: '로그인 처리 중 오류: ${e.toString()}',
        isLoginLoading: false,
      );
    }
  }

  /// 지갑 설정 안내 화면으로 이동
  void moveToWalletSetup() {
    state = state.copyWith(currentStep: AuthStep.walletSetup);
  }

  /// 지갑 생성 화면으로 이동 (별도 라우트 사용)
  void moveToWalletCreation(BuildContext context) {
    // WalletNotifier 상태 초기화
    ref.read(walletNotifierProvider.notifier).reset();

    // Auth 상태는 변경하지 않고, 네비게이션만 처리
    // state = state.copyWith(currentStep: AuthStep.walletCreation); // 이 줄은 제거하거나 주석 처리

    // '/wallet-creation' 라우트로 이동하며 WalletNotifier Provider 전달
    // context.mounted 체크는 GoRouter 내부에서 처리될 수 있으나, 명시적으로 추가하는 것이 안전할 수 있음
    if (context.mounted) {
      context.push('/wallet-creation', extra: walletNotifierProvider);
    }
  }

  /* --- 네트워크 연결 단계 이동 메서드 (제거 또는 주석 처리) ---
  // void moveToNetworkConnection() {
  //   // 스플래시에서 네트워크 연결을 처리하므로 이 단계는 불필요
  //   print("moveToNetworkConnection is deprecated. Completing auth directly.");
  //   completeAuth();
  // }
  */

  /// 인증 완료 처리
  void completeAuth() {
    print("Authentication completed. Setting state to AuthStep.completed.");
    // 스플래시에서 블록체인 연결이 완료되었다고 가정하고 바로 완료 상태로 변경
    state = state.copyWith(currentStep: AuthStep.completed);
    // AuthScreen의 build 메서드에서 이 상태를 감지하여 홈 화면으로 이동
  }

  /// 에러 발생 시 처리 (로그인 단계로 돌아가도록 수정)
  void handleErrorRetry() {
    print("Handling error retry. Returning to login step.");
    // 에러 발생 시 로그인 단계로 초기화
    initializeAuth();
    // WalletNotifier 상태도 초기화 필요 시 추가
    ref.read(walletNotifierProvider.notifier).reset();
  }

  /// 인증 흐름 및 관련 상태 초기화
  void reset() {
    print("Resetting AuthNotifier state.");
    ref.read(walletNotifierProvider.notifier).reset(); // Wallet 상태도 초기화
    state = AuthState(); // Auth 상태를 기본값으로 초기화
  }
}

/// 인증 뷰 모델 프로바이더 (변경 없음)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_response.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';
import 'package:kkuk_kkuk/services/auth_service.dart';
import 'package:kkuk_kkuk/services/wallet_service.dart';

/// 로그인 상태를 관리하는 클래스
class LoginState {
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지
  final KakaoAuthResponse? authResponse;

  LoginState({this.isLoading = false, this.error, this.authResponse});

  LoginState copyWith({
    bool? isLoading,
    String? error,
    KakaoAuthResponse? authResponse,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      authResponse: authResponse ?? this.authResponse,
    );
  }
}

/// 로그인 상태 관리 노티파이어
class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  final AuthService _authService;
  final WalletService _walletService;

  LoginNotifier(this.ref, this._authService, this._walletService)
    : super(LoginState());

  /// 카카오 로그인 처리
  Future<void> signInWithKakao() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _authService.signInWithKakao();
      state = state.copyWith(authResponse: response, isLoading: false);

      // 지갑 존재 여부 확인
      final hasWallet = response.data.wallet != null;

      if (hasWallet) {
        // 지갑이 이미 있는 경우
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } else {
        // 지갑이 없는 경우 지갑 설정 화면으로 이동
        ref.read(walletProvider.notifier).reset(); // 지갑 상태 초기화
        ref.read(authCoordinatorProvider.notifier).moveToWalletSetup();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그인 실패: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.logout();
      state = LoginState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그아웃 실패: $e');
      rethrow;
    }
  }

  /// 상태 초기화
  void reset() {
    state = LoginState();
  }
}

/// 로그인 프로바이더
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final walletService = ref.watch(walletServiceProvider);
  return LoginNotifier(ref, authService, walletService);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/services/auth_service.dart';
import 'package:kkuk_kkuk/services/wallet_service.dart';

/// 로그인 상태를 관리하는 클래스
class LoginState {
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지

  LoginState({this.isLoading = false, this.error});

  /// 상태 복사 메서드
  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
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
    // 로딩 상태로 전환
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 카카오 로그인 시도
      await _authService.signInWithKakao();

      // 지갑 존재 여부 확인
      final hasWallet = await _walletService.checkWalletExists();
      if (hasWallet) {
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } else {
        ref.read(authCoordinatorProvider.notifier).moveToWalletSetup();
      }

      // 로딩 상태 해제
      state = state.copyWith(isLoading: false);
    } catch (e) {
      // 에러 처리
      state = state.copyWith(
        isLoading: false,
        error: '로그인에 실패했습니다. 다시 시도해주세요.',
      );
      ref.read(authCoordinatorProvider.notifier).handleError();
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

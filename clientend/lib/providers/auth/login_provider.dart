import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/services/auth_service.dart';
import 'package:kkuk_kkuk/services/wallet_service.dart';

class LoginState {
  final bool isLoading;
  final String? error;

  LoginState({this.isLoading = false, this.error});

  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  final AuthService _authService;
  final WalletService _walletService;

  LoginNotifier(this.ref, this._authService, this._walletService)
    : super(LoginState());

  Future<void> signInWithKakao() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.signInWithKakao();

      final hasWallet = await _walletService.checkWalletExists();
      if (hasWallet) {
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } else {
        ref.read(authCoordinatorProvider.notifier).moveToWalletSetup();
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '로그인에 실패했습니다. 다시 시도해주세요.',
      );
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void reset() {
    state = LoginState();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final walletService = ref.watch(walletServiceProvider);
  return LoginNotifier(ref, authService, walletService);
});

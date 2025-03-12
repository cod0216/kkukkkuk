import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';

class LoginState {
  final bool isLoading;
  final String? error;

  LoginState({
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;

  LoginNotifier(this.ref) : super(LoginState());

  Future<void> signInWithKakao() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement actual Kakao login
      await Future.delayed(const Duration(seconds: 2));
      
      final hasWallet = await checkWallet();
      if (hasWallet) {
        ref.read(authCoordinatorProvider.notifier).moveToPinSetup();
      } else {
        ref.read(authCoordinatorProvider.notifier).moveToWalletCreation();
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

  Future<bool> checkWallet() async {
    // TODO: Implement wallet check
    return false;
  }

  void reset() {
    state = LoginState();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

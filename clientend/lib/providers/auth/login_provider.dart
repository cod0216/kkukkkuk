import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';

/// 로그인 상태를 관리하는 클래스
class LoginState {
  final bool isLoading;
  final String? error;
  final AuthenticateResponse? authResponse;

  LoginState({this.isLoading = false, this.error, this.authResponse});

  LoginState copyWith({
    bool? isLoading,
    String? error,
    AuthenticateResponse? authResponse,
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

  LoginNotifier(this.ref) : super(LoginState());

  Future<void> signInWithKakao() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final loginUseCase = ref.read(loginWithKakaoUseCaseProvider);
      final response = await loginUseCase.execute();
      
      state = state.copyWith(authResponse: response, isLoading: false);

      final hasWallet = response.data.wallet != null;

      if (hasWallet) {
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } else {
        ref.read(walletProvider.notifier).reset();
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
      
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final success = await logoutUseCase.execute();
      
      if (success) {
        state = LoginState();
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그아웃 실패: $e');
      rethrow;
    }
  }

  void reset() {
    state = LoginState();
  }
}

/// 로그인 프로바이더
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

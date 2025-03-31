import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/providers/wallet/wallet_provider.dart';

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
  final _secureStorage = const FlutterSecureStorage();
  static const String _privateKeyKey = 'eth_private_key';

  LoginNotifier(this.ref) : super(LoginState());

  Future<void> signInWithKakao() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final loginUseCase = ref.read(loginWithKakaoUseCaseProvider);
      final response = await loginUseCase.execute();

      state = state.copyWith(authResponse: response, isLoading: false);

      // 로컬 스토리지에 개인키 저장 확인
      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final hasWallet = privateKey != null && privateKey.isNotEmpty;

      final authController = ref.read(authControllerProvider.notifier);
      if (hasWallet) {
        // 개인키가 있으면 네트워크 연결 화면으로 이동
        authController.moveToNetworkConnection();
      } else {
        // 개인키가 없으면 지갑 생성 화면으로 이동
        ref.read(walletProvider.notifier).reset();
        authController.moveToWalletSetup();
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

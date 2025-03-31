import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';

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
// LoginProvider를 단순화하여 데이터 접근만 담당
class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  final _secureStorage = const FlutterSecureStorage();
  static const String _privateKeyKey = 'eth_private_key';

  LoginNotifier(this.ref) : super(LoginState());

  // 로그인 처리만 담당하고 결과 반환
  Future<AuthResult> signInWithKakao() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final loginUseCase = ref.read(loginWithKakaoUseCaseProvider);
      final response = await loginUseCase.execute();

      state = state.copyWith(authResponse: response, isLoading: false);

      // 로컬 스토리지에 개인키 저장 확인
      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final hasWallet = privateKey != null && privateKey.isNotEmpty;

      // 결과만 반환하고 상태 변경은 하지 않음
      return AuthResult(
        success: true,
        hasWallet: hasWallet,
        response: response,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그인 실패: $e');
      return AuthResult(success: false, error: e.toString());
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

// 로그인 결과를 담는 클래스
class AuthResult {
  final bool success;
  final bool hasWallet;
  final String? error;
  final AuthenticateResponse? response;

  AuthResult({
    required this.success,
    this.hasWallet = false,
    this.error,
    this.response,
  });
}

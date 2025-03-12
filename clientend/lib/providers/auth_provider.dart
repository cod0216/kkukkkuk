import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState {
  initial,
  authenticating,
  authenticated,
  error,
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.initial);

  Future<bool> signInWithKakao() async {
    state = AuthState.authenticating;
    
    try {
      // TODO: 카카오API로그인 구현
      // 실제 카카오 로그인 로직은 나중에 구현
      await Future.delayed(const Duration(seconds: 2)); // 로딩 시뮬레이션
      
      // 임시로 로그인 성공으로 처리
      state = AuthState.authenticated;
      return true;
    } catch (e) {
      state = AuthState.error;
      return false;
    }
  }

  void signOut() {
    state = AuthState.initial;
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});
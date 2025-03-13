import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  // Login methods
  Future<bool> signInWithKakao() async {
    // TODO: Kakao login
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> logout() async {
    // TODO: Logout
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> refreshToken() async {
    // TODO: refresh token
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

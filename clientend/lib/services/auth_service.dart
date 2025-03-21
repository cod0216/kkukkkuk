import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/models/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/models/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/repositories/auth_repository.dart';
import 'package:kkuk_kkuk/services/oauth_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final OAuthService _oAuthService;

  AuthService(this._authRepository, this._oAuthService);

  /// 카카오를 이용한 로그인/회원가입
  Future<AuthenticateResponse> authenticateWithKakao(User kakaoUser) async {
    try {
      final request = AuthenticateRequest(
        name: kakaoUser.kakaoAccount?.name ?? '',
        email: kakaoUser.kakaoAccount?.email ?? '',
        birthyear: kakaoUser.kakaoAccount?.birthyear ?? '',
        birthday: kakaoUser.kakaoAccount?.birthday ?? '',
        gender: kakaoUser.kakaoAccount?.gender?.toString().toLowerCase() ?? '',
        providerId: kakaoUser.id.toString(),
      );

      return await _authRepository.authenticateAPI(request);
    } catch (error) {
      print('authenticateWithKakao Error: $error');
      rethrow;
    }
  }

  /// 통합 로그인 프로세스
  Future<AuthenticateResponse> login() async {
    try {
      // 카카오 인증
      final kakaoUser = await _oAuthService.kakaoOAuth();

      // 서버 인증
      return await authenticateWithKakao(kakaoUser);
    } catch (error) {
      print('login Error: $error');
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      // 카카오 로그아웃
      await _oAuthService.kakaoLogout();

      // 서버 로그아웃
      return await _authRepository.logout();
    } catch (e) {
      print('logout Error: $e');
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final kakaoService = ref.watch(kakaoServiceProvider);
  return AuthService(authRepository, kakaoService);
});

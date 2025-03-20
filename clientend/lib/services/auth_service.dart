import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_request.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_response.dart';
import 'package:kkuk_kkuk/repositories/auth_repository.dart';
import 'package:kkuk_kkuk/services/kakao_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final KakaoService _kakaoService;

  AuthService(this._authRepository, this._kakaoService);

  /// 서버 로그인/회원가입
  Future<KakaoAuthResponse> authenticateWithServer(User kakaoUser) async {
    try {
      final request = KakaoAuthRequest(
        name: kakaoUser.kakaoAccount?.name ?? '',
        email: kakaoUser.kakaoAccount?.email ?? '',
        birthyear: kakaoUser.kakaoAccount?.birthyear ?? '',
        birthday: kakaoUser.kakaoAccount?.birthday ?? '',
        gender: kakaoUser.kakaoAccount?.gender?.toString().toLowerCase() ?? '',
        providerId: kakaoUser.id.toString(),
      );

      return await _authRepository.signInWithKakao(request);
    } catch (error) {
      print('서버 인증 실패: $error');
      throw Exception('서버 인증 실패: $error');
    }
  }

  /// 통합 로그인 프로세스
  Future<KakaoAuthResponse> signInWithKakao() async {
    try {
      // 카카오 인증
      final kakaoUser = await _kakaoService.authenticate();

      // 서버 인증
      return await authenticateWithServer(kakaoUser);
    } catch (error) {
      print('로그인 프로세스 실패: $error');
      throw Exception('로그인 프로세스 실패: $error');
    }
  }

  Future<bool> logout() async {
    try {
      // 카카오 로그아웃
      await _kakaoService.logout();

      // 서버 로그아웃
      return await _authRepository.logout();
    } catch (e) {
      print('로그아웃 실패: $e');
      throw Exception('로그아웃 실패: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      return await _authRepository.isLoggedIn();
    } catch (e) {
      print('로그인 상태 확인 실패: $e');
      return false;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final kakaoService = ref.watch(kakaoServiceProvider);
  return AuthService(authRepository, kakaoService);
});

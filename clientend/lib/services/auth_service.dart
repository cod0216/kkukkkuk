import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_request.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_response.dart';
import 'package:kkuk_kkuk/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<KakaoAuthResponse> signInWithKakao() async {
    try {
      // 카카오톡 설치 여부 확인
      final installed = await isKakaoTalkInstalled();
      if (installed) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      User user = await UserApi.instance.me();

      // TODO: 사용자 정보 및 토큰 저장 로직 추가
      final request = KakaoAuthRequest(
        name: user.kakaoAccount?.name ?? '',
        email: user.kakaoAccount?.email ?? '',
        birthyear: user.kakaoAccount?.birthyear ?? '',
        birthday: user.kakaoAccount?.birthday ?? '',
        gender: user.kakaoAccount?.gender?.toString().toLowerCase() ?? 'female',
        providerId: user.id.toString(),
      );

      try {
        final response = await _authRepository.signInWithKakao(request);
        return response;
      } catch (serverError) {
        print('서버 에러: $serverError');
        rethrow;
      }
    } catch (error) {
      print('카카오 로그인 실패: $error');
      throw Exception('카카오 로그인 실패: $error');
    }
  }

  Future<bool> logout() async {
    // TODO: 로컬 저장소의 인증 정보 삭제
    // TODO: 서버에 로그아웃 요청 전송
    try {
      await UserApi.instance.logout();
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
  return AuthService(authRepository);
});

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthService {
  Future<bool> signInWithKakao() async {
    try {
      OAuthToken token;
      // 카카오톡 설치 여부 확인
      final installed = await isKakaoTalkInstalled();
      if (installed) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      token.accessToken;
      User user = await UserApi.instance.me();

      // TODO: 카카오 로그인 후 서버 인증 처리
      // TODO: 사용자 정보 및 토큰 저장 로직 추가
      print('Kakao login success: ${user.id}, ${token.accessToken}');
      return true;
    } catch (error) {
      print('Kakao login failed: $error');
      throw Exception('Kakao login failed: $error');
    }
  }

  Future<bool> logout() async {
    // TODO: 로컬 저장소의 인증 정보 삭제
    // TODO: 서버에 로그아웃 요청 전송
    // TODO: 소셜 로그인 연동 해제 처리
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> isLoggedIn() async {
    // TODO: 로컬 저장소의 토큰 유효성 검사
    // TODO: 필요시 서버에 토큰 검증 요청
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> refreshToken() async {
    // TODO: 리프레시 토큰을 사용하여 새 액세스 토큰 요청
    // TODO: 토큰 만료 시간 검증 로직 추가
    // TODO: 갱신된 토큰 저장 처리
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

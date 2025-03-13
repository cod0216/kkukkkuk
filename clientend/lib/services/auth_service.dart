import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<bool> signInWithKakao() async {
    // TODO: 카카오 SDK 연동 구현
    // TODO: 카카오 로그인 후 서버 인증 처리
    // TODO: 사용자 정보 및 토큰 저장 로직 추가
    await Future.delayed(const Duration(seconds: 2));
    return true;
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

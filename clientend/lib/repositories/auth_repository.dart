import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_request.dart';
import 'package:kkuk_kkuk/models/auth/kakao_auth_response.dart';
import 'package:kkuk_kkuk/services/api_client.dart';

/// 인증 관련 API 요청을 처리하는 저장소
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// 카카오 로그인 API 호출
  Future<KakaoAuthResponse> signInWithKakao(KakaoAuthRequest request) async {
    try {
      final response = await _apiClient.post(
        '/api/auths/owners/kakao/login',
        data: request.toJson(),
      );

      return KakaoAuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('카카오 로그인 API 에러: ${e.message}');
      if (e.response != null) {
        print('에러 응답: ${e.response!.data}');
      }
      rethrow;
    } catch (e) {
      print('카카오 로그인 중 예상치 못한 에러: $e');
      rethrow;
    }
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    try {
      // TODO: 토큰 유효성 검사 구현
      return false;
    } catch (e) {
      print('로그인 상태 확인 실패: $e');
      return false;
    }
  }

  /// 로그아웃
  Future<bool> logout() async {
    try {
      // TODO: 로그아웃 API 구현
      return true;
    } catch (e) {
      print('로그아웃 실패: $e');
      return false;
    }
  }

  /// 토큰 갱신
  Future<bool> refreshToken() async {
    try {
      // TODO: 토큰 갱신 API 구현
      return false;
    } catch (e) {
      print('토큰 갱신 실패: $e');
      return false;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

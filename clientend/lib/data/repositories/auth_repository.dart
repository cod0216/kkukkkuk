import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/api/api_client.dart';
import 'package:kkuk_kkuk/models/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/models/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/services/token_manager.dart';

/// 인증 관련 API 요청을 처리하는 저장소
class AuthRepository {
  final ApiClient _apiClient;
  final TokenManager _tokenManager;

  AuthRepository(this._apiClient, this._tokenManager);

  /// 서버 인증증 API 호출
  Future<AuthenticateResponse> authenticateAPI(
    AuthenticateRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/auths/owners/kakao/login',
        data: request.toJson(),
      );

      final authResponse = AuthenticateResponse.fromJson(response.data);

      // 토큰 저장
      await _tokenManager.saveAccessToken(authResponse.data.tokens.accessToken);
      await _tokenManager.saveRefreshToken(
        authResponse.data.tokens.refreshToken,
      );

      return authResponse;
    } catch (e) {
      print('authenticateAPI Error: $e');
      rethrow;
    }
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    try {
      // 저장된 토큰 확인
      final accessToken = await _tokenManager.getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      print('로그인 상태 확인 실패: $e');
      return false;
    }
  }

  /// 로그아웃
  Future<bool> logout() async {
    try {
      // TODO: 로그아웃 API 구현

      // 로컬 토큰 삭제
      await _tokenManager.clearTokens();
      return true;
    } catch (e) {
      print('로그아웃 실패: $e');
      return false;
    }
  }

  /// 토큰 갱신
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
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
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthRepository(apiClient, tokenManager);
});

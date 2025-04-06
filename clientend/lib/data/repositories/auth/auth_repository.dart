import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/api_client.dart';
import 'package:kkuk_kkuk/data/repositories/auth/token_repository.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/auth_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/token_repository_interface.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/data/dtos/auth/logout_response.dart';

class AuthRepository implements IAuthRepository {
  final ApiClient _apiClient;
  final ITokenRepository _tokenRepository;

  AuthRepository(this._apiClient, this._tokenRepository);

  @override
  Future<void> authenticate(String accessToken, String refreshToken) async {
    await _tokenRepository.saveAccessToken(accessToken);
    await _tokenRepository.saveRefreshToken(refreshToken);
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await _tokenRepository.getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      print('로그인 상태 확인 실패: $e');
      return false;
    }
  }

  @override
  Future<LogoutResponse> logout() async {
    try {
      // API 호출
      final response = await _apiClient.post('/api/auths/logout');

      // 응답 파싱
      final logoutResponse = LogoutResponse.fromJson(response.data);

      // 로컬 토큰 삭제
      await _tokenRepository.clearTokens();

      return logoutResponse;
    } catch (e) {
      print('로그아웃 실패: $e');
      rethrow;
    }
  }

  @override
  Future<AuthenticateResponse> authenticateWithKakao(
    AuthenticateRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/auths/owners/kakao/login',
        data: request.toJson(),
      );

      final authResponse = AuthenticateResponse.fromJson(response.data);

      // Use the authenticate method
      await authenticate(
        authResponse.data.tokens.accessToken,
        authResponse.data.tokens.refreshToken,
      );

      return authResponse;
    } catch (e) {
      print('Authentication failed: $e');
      throw Exception('Authentication failed: $e');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return AuthRepository(apiClient, tokenRepository);
});

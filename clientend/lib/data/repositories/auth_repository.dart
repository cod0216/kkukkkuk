import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/api/api_client.dart';
import 'package:kkuk_kkuk/data/repositories/token_repository.dart';
import 'package:kkuk_kkuk/domain/repositories/auth_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/token_repository_interface.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';

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
  Future<bool> logout() async {
    try {
      await _tokenRepository.clearTokens();
      return true;
    } catch (e) {
      print('로그아웃 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenRepository.getRefreshToken();
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

  // Repository 전용 메서드
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
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return AuthRepository(apiClient, tokenRepository);
});

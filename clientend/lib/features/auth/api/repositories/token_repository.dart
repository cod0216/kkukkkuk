import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/lib/storage/secure_storage.dart';
import 'package:kkuk_kkuk/features/auth/api/interfaces/token_repository_interface.dart';

class TokenRepository implements ITokenRepository {
  final SecureStorage _secureStorage;

  // 토큰 키 상수
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenRepository(this._secureStorage);

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.saveValue(_accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.saveValue(_refreshTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.getValue(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getValue(_refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.removeValue(_accessTokenKey);
    await _secureStorage.removeValue(_refreshTokenKey);
  }
}

final tokenRepositoryProvider = Provider<ITokenRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenRepository(secureStorage);
});

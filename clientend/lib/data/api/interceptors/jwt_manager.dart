import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/services/token_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JwtManager extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final TokenManager tokenManager;

  JwtManager(this.tokenManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 저장된 토큰 가져오기
    final token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답에서 새 토큰이 있으면 저장
    if (response.headers.map.containsKey('x-auth-token')) {
      final newToken = response.headers.value('x-auth-token');
      _saveToken(newToken ?? '');
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 시 토큰 리프레시 로직
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null) {
          // 토큰 리프레시 요청
          final dio = Dio();
          final response = await dio.post(
            'https://your-api-base-url.com/api/refresh-token',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newToken = response.data['token'];
            await _saveToken(newToken);

            // 원래 요청 재시도
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        // 리프레시 실패 시 로그아웃 처리
        await _storage.deleteAll();
        // TODO: 로그아웃 처리 로직 추가
      }
    }

    return handler.next(err);
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }
}

final jwtInterceptorProvider = Provider<JwtManager>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return JwtManager(tokenManager);
});

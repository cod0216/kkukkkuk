import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/token_repository.dart';
import 'package:kkuk_kkuk/domain/repositories/token_repository_interface.dart';

class JwtManager extends Interceptor {
  final ITokenRepository tokenRepository;

  JwtManager(this.tokenRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 저장된 토큰 가져오기
    final token = await tokenRepository.getAccessToken();

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
      if (newToken != null) {
        tokenRepository.saveAccessToken(newToken);
      }
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 시 토큰 리프레시 로직
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await tokenRepository.getRefreshToken();
        if (refreshToken != null) {
          // 토큰 리프레시 요청
          final dio = Dio();
          final response = await dio.post(
            'https://kukkkukk.duckdns.org/api/refresh-token',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newToken = response.data['access_token'];
            await tokenRepository.saveAccessToken(newToken);

            // 원래 요청 재시도
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        print('토큰 갱신 실패: $e');
      }
    }

    return handler.next(err);
  }
}

final jwtInterceptorProvider = Provider<JwtManager>((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return JwtManager(tokenRepository);
});

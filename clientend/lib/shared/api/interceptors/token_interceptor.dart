import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/api_client.dart';
import 'package:kkuk_kkuk/features/auth/api/dto/token_refresh_response.dart';
import 'package:kkuk_kkuk/features/auth/api/repositories/token_repository.dart';
import 'package:kkuk_kkuk/features/auth/api/interfaces/token_repository_interface.dart';

class TokenIntercepter extends Interceptor {
  final ITokenRepository tokenRepository;
  final Dio dio;

  // 동시 토큰 갱신 방지를 위한 플래그
  bool _isRefreshing = false;

  // 대기 중인 요청 큐
  final List<_RetryRequest> _pendingRequests = [];

  // 최대 재시도 횟수
  static const int _maxRetryCount = 3;

  TokenIntercepter(this.tokenRepository, this.dio);

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

  // 토큰 갱신 메서드
  Future<TokenRefreshResponse?> refreshTokenRequest(String refreshToken) async {
    try {
      // 토큰 갱신 요청
      final response = await dio.post(
        '/api/refresh-token',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
          // 요청 타임아웃 설정
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        return TokenRefreshResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('토큰 갱신 요청 실패 (DioException): ${e.type} - ${e.message}');
      return null;
    } catch (e) {
      print('토큰 갱신 요청 실패: $e');
      return null;
    }
  }

  // 대기 중인 요청 처리
  void _processQueue(String? accessToken) {
    for (var request in _pendingRequests) {
      if (accessToken != null) {
        request.options.headers['Authorization'] = 'Bearer $accessToken';
        request.completer.complete(dio.fetch(request.options));
      } else {
        // 토큰 갱신 실패 시 에러 반환
        request.completer.completeError(
          DioException(
            requestOptions: request.options,
            error: 'Token refresh failed',
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
    _pendingRequests.clear();
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 시 토큰 리프레시 로직
    if (err.response?.statusCode == 401) {
      // 재시도 횟수 확인
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      if (retryCount >= _maxRetryCount) {
        print('최대 재시도 횟수 초과: $retryCount');
        return handler.next(err);
      }

      // 현재 요청 정보
      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;

      try {
        final refreshToken = await tokenRepository.getRefreshToken();
        if (refreshToken == null) {
          return handler.next(err);
        }

        // 대기 중인 요청 생성
        final completer = Completer<Response<dynamic>>();
        final retryRequest = _RetryRequest(options, completer);

        // 이미 토큰 갱신 중이면 큐에 추가
        if (_isRefreshing) {
          _pendingRequests.add(retryRequest);
          try {
            final response = await completer.future;
            return handler.resolve(response);
          } catch (e) {
            return handler.next(err);
          }
        }

        // 토큰 갱신 시작
        _isRefreshing = true;

        try {
          // 토큰 갱신 요청
          final tokenResponse = await refreshTokenRequest(refreshToken);

          if (tokenResponse != null) {
            // 새 토큰 저장
            await tokenRepository.saveAccessToken(
              tokenResponse.data.accessToken,
            );
            await tokenRepository.saveRefreshToken(
              tokenResponse.data.refreshToken,
            );

            // 원래 요청 재시도
            options.headers['Authorization'] =
                'Bearer ${tokenResponse.data.accessToken}';

            // 대기 중인 요청 처리
            _processQueue(tokenResponse.data.accessToken);

            final retryResponse = await dio.fetch(options);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          } else {
            // TODO: 로그인 필요 상태로 처리
            print('토큰 갱신 실패: 응답이 없거나 유효하지 않음');
            _processQueue(null);
            _isRefreshing = false;
          }
        } catch (e) {
          print('토큰 갱신 처리 중 오류 발생: $e');
          _processQueue(null);
          _isRefreshing = false;
          // TODO: 로그인 필요 상태로 처리
        }
      } catch (e) {
        print('토큰 갱신 전 오류 발생: $e');
      }
    }

    return handler.next(err);
  }
}

// 재시도 요청을 위한 클래스
class _RetryRequest {
  final RequestOptions options;
  final Completer<Response<dynamic>> completer;

  _RetryRequest(this.options, this.completer);
}

final tokenInterceptorProvider = Provider<TokenIntercepter>((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  final dio = ref.watch(dioProvider);
  return TokenIntercepter(tokenRepository, dio);
});

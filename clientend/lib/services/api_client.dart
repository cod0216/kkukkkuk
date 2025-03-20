import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/services/token_manager.dart';

/// API 통신을 담당하는 클라이언트
class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;
  final String baseUrl = 'https://kukkkukk.duckdns.org';

  // 토큰 재발급 중인지 여부
  bool _isRefreshing = false;

  // 토큰 재발급 중 대기 중인 요청들
  final List<_RequestRetry> _pendingRequests = [];

  ApiClient(this._tokenManager) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 토큰 인증 인터셉터 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenManager.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // 401 에러 처리 (토큰 만료)
          if (error.response?.statusCode == 401) {
            try {
              final requestOptions = error.requestOptions;

              // 토큰 재발급 요청 중이면 대기열에 추가
              if (_isRefreshing) {
                final completer = _addToPendingRequests(requestOptions);
                return handler.resolve(await completer.future);
              }

              _isRefreshing = true;

              // 토큰 재발급 시도
              final isRefreshed = await _refreshToken();

              if (isRefreshed) {
                // 토큰 재발급 성공, 원래 요청 재시도
                final token = await _tokenManager.getAccessToken();
                requestOptions.headers['Authorization'] = 'Bearer $token';

                // 대기 중인 요청들 처리
                _resolvePendingRequests(token!);

                // 원래 요청 재시도
                final response = await _retry(requestOptions);
                return handler.resolve(response);
              } else {
                // 토큰 재발급 실패, 로그인 화면으로 이동
                // TODO: 로그인 화면으로 이동 로직 구현

                _rejectPendingRequests();
                return handler.next(error);
              }
            } catch (e) {
              print('토큰 갱신 중 오류: $e');
              return handler.next(error);
            } finally {
              _isRefreshing = false;
            }
          }

          return handler.next(error);
        },
      ),
    );

    // 로깅 인터셉터 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('요청[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '응답[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            '에러[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          return handler.next(e);
        },
      ),
    );
  }

  /// 토큰 재발급 요청
  Future<bool> _refreshToken() async {
    try {
      // TODO: 토큰 재발급 API 구현
      return false;
    } catch (e) {
      print('토큰 재발급 실패: $e');
      return false;
    }
  }

  /// 대기 중인 요청에 추가
  Completer<Response> _addToPendingRequests(RequestOptions requestOptions) {
    final completer = Completer<Response>();
    _pendingRequests.add(
      _RequestRetry(requestOptions: requestOptions, completer: completer),
    );
    return completer;
  }

  /// 대기 중인 요청 처리
  void _resolvePendingRequests(String token) {
    for (final request in _pendingRequests) {
      request.requestOptions.headers['Authorization'] = 'Bearer $token';
      _retry(request.requestOptions).then(
        (response) => request.completer.complete(response),
        onError: (error) => request.completer.completeError(error),
      );
    }
    _pendingRequests.clear();
  }

  /// 대기 중인 요청 거부
  void _rejectPendingRequests() {
    for (final request in _pendingRequests) {
      request.completer.completeError(
        DioException(
          requestOptions: request.requestOptions,
          error: '토큰 재발급 실패',
          type: DioExceptionType.unknown,
        ),
      );
    }
    _pendingRequests.clear();
  }

  /// 요청 재시도
  Future<Response> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// HTTP GET 요청
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// HTTP POST 요청
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// HTTP PUT 요청
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// HTTP DELETE 요청
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Dio 에러 처리
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('서버 연결 시간 초과');
      case DioExceptionType.receiveTimeout:
        throw Exception('서버 응답 시간 초과');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        throw Exception('서버 오류 (상태 코드: $statusCode) - $data');
      case DioExceptionType.cancel:
        throw Exception('요청이 취소됨');
      default:
        throw Exception('네트워크 오류: ${e.message}');
    }
  }

  Dio get dio => _dio;
}

/// 대기 중인 요청 정보를 담는 클래스
class _RequestRetry {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  _RequestRetry({required this.requestOptions, required this.completer});
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return ApiClient(tokenManager);
});

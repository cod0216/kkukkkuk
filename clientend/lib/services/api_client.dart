import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API 통신을 담당하는 클라이언트
class ApiClient {
  final Dio _dio;
  final String baseUrl = 'https://kukkkukk.duckdns.org';

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // TODO: 토큰 인터셉터 구현
    // TODO: 토큰 갱신 로직 구현
    // TODO: 요청 재시도 로직 구현

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

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/interceptors/error_handler.dart';
import 'package:kkuk_kkuk/shared/api/interceptors/token_interceptor.dart';
import 'package:kkuk_kkuk/shared/api/interceptors/logging_interceptor.dart';
import 'package:kkuk_kkuk/shared/config/app_config.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  void addInterceptors(List<Interceptor> interceptors) {
    for (final interceptor in interceptors) {
      _dio.interceptors.add(interceptor);
    }
  }

  // HTTP 요청 메소드
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> multipartPost(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters = const {},
    Options? options,
  }) {
    final defaultOptions = Options(
      contentType: 'multipart/form-data',
      responseType: ResponseType.plain,
    );

    final mergedOptions =
        options?.copyWith(
          contentType: options.contentType ?? defaultOptions.contentType,
          responseType: options.responseType ?? defaultOptions.responseType,
        ) ??
        defaultOptions;

    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: mergedOptions,
    );
  }
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final apiClient = ApiClient(dio);

  // 인터셉터 추가
  final jwtInterceptor = ref.watch(tokenInterceptorProvider);
  final errorHandler = ErrorHandler();
  final loggingInterceptor = LoggingInterceptor();

  apiClient.addInterceptors([jwtInterceptor, errorHandler, loggingInterceptor]);

  return apiClient;
});

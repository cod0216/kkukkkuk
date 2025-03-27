import 'package:dio/dio.dart';

class ErrorHandler extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 에러 처리 로직
    print('API Error: ${err.message}');

    // 에러 상태 코드에 따른 처리
    switch (err.response?.statusCode) {
      case 401:
        print('인증 에러 발생');
        // 인증 에러 처리 로직
        break;
      case 404:
        print('리소스를 찾을 수 없습니다');
        break;
      case 500:
        print('서버 에러 발생');
        break;
      default:
        print('기타 에러 발생');
    }

    return handler.next(err);
  }
}

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/oauth_repository_interface.dart';

class KakaoOAuthUseCase {
  final IOAuthRepository _repository;

  KakaoOAuthUseCase(this._repository);

  Future<User> execute() async {
    try {
      return await _repository.kakaoLogin();
    } catch (e) {
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

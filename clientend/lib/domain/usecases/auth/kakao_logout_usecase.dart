import 'package:kkuk_kkuk/domain/repositories/oauth_repository_interface.dart';

class KakaoLogoutUseCase {
  final IOAuthRepository _repository;

  KakaoLogoutUseCase(this._repository);

  Future<void> execute() async {
    try {
      await _repository.kakaoLogout();
    } catch (e) {
      throw Exception('Failed to logout from Kakao: $e');
    }
  }
}
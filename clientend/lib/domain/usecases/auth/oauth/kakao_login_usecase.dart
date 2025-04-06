import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/oauth_repository_interface.dart';

class KakaoLoginUseCase {
  final IOAuthRepository _repository;

  KakaoLoginUseCase(this._repository);

  Future<User> execute() async {
    try {
      // 카카오 로그인
      final user = await _repository.kakaoLogin();
      // 로그인 성공 시 유저 정보 반환
      User userInfo = User(
        id: 0,
        name: user.kakaoAccount?.name ?? '',
        email: user.kakaoAccount?.email ?? '',
        birthYear: user.kakaoAccount?.birthyear ?? '',
        birthDay: user.kakaoAccount?.birthday ?? '',
        gender: user.kakaoAccount?.gender?.name ?? '',
        providerId: user.id,
      );

      return userInfo;
    } catch (e) {
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

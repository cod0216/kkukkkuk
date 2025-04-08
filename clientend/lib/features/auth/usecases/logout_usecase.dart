import 'package:kkuk_kkuk/features/auth/api/interfaces/auth_repository_interface.dart';
import 'package:kkuk_kkuk/features/auth/api/interfaces/oauth_repository_interface.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;
  final IOAuthRepository _oAuthRepository;

  LogoutUseCase(this._authRepository, this._oAuthRepository);

  Future<bool> execute() async {
    try {
      // 카카오 로그아웃 먼저 실행
      await _oAuthRepository.kakaoLogout();

      // 서버 로그아웃 실행
      await _authRepository.logout();
      return true;
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }
}

import 'package:kkuk_kkuk/domain/repositories/auth_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/oauth_repository_interface.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;
  final IOAuthRepository _oAuthRepository;

  LogoutUseCase(this._authRepository, this._oAuthRepository);

  Future<bool> execute() async {
    try {
      await _oAuthRepository.kakaoLogout();
      return await _authRepository.logout();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/domain/entities/user.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/auth_repository_interface.dart';

class LoginWithKakaoUseCase {
  final IAuthRepository _authRepository;

  LoginWithKakaoUseCase(this._authRepository);

  Future<bool> execute(User user) async {
    try {
      final request = AuthenticateRequest(
        name: user.name,
        email: user.email,
        birthyear: user.birthYear,
        birthday: user.birthDay,
        gender: user.gender,
        providerId: user.providerId.toString(),
      );

      await _authRepository.authenticateWithKakao(request);
      print('Backend authentication successful');
      return true;
    } catch (e) {
      print('Failed to login with Kakao: $e');
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

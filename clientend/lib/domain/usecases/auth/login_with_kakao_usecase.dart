import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/domain/repositories/auth_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/oauth_repository_interface.dart';

class LoginWithKakaoUseCase {
  final IAuthRepository _authRepository;
  final IOAuthRepository _oAuthRepository;

  LoginWithKakaoUseCase(this._authRepository, this._oAuthRepository);

  Future<AuthenticateResponse> execute() async {
    try {
      // 1. Kakao OAuth
      final kakaoUser = await _oAuthRepository.kakaoLogin();

      // 2. Create request
      final request = AuthenticateRequest(
        name: kakaoUser.kakaoAccount?.name ?? '',
        email: kakaoUser.kakaoAccount?.email ?? '',
        birthyear: kakaoUser.kakaoAccount?.birthyear ?? '',
        birthday: kakaoUser.kakaoAccount?.birthday ?? '',
        gender: kakaoUser.kakaoAccount?.gender?.toString().toLowerCase() ?? '',
        providerId: kakaoUser.id.toString(),
      );

      // 3. Authenticate with backend
      return await _authRepository.authenticateWithKakao(request);
    } catch (e) {
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

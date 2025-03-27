import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/auth_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/oauth_repository_interface.dart';

class LoginWithKakaoUseCase {
  final IAuthRepository _authRepository;
  final IOAuthRepository _oAuthRepository;

  LoginWithKakaoUseCase(this._authRepository, this._oAuthRepository);

  Future<AuthenticateResponse> execute() async {
    try {
      // 1. Kakao OAuth
      final kakaoUser = await _oAuthRepository.kakaoLogin();
      print('Kakao login successful: ${kakaoUser.id}');

      // 2. Create request
      final request = AuthenticateRequest(
        name: kakaoUser.kakaoAccount?.name ?? '',
        email: kakaoUser.kakaoAccount?.email ?? '',
        birthyear: kakaoUser.kakaoAccount?.birthyear ?? '',
        birthday: kakaoUser.kakaoAccount?.birthday ?? '',
        gender: kakaoUser.kakaoAccount?.gender?.toString().toLowerCase() ?? '',
        providerId: kakaoUser.id.toString(),
      );
      print('Auth request created: ${request.email}');

      // 3. Authenticate with backend
      final response = await _authRepository.authenticateWithKakao(request);
      print('Backend authentication successful');
      return response;
    } catch (e) {
      print('Failed to login with Kakao: $e');
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

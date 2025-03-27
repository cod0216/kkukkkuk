import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/data/dtos/auth/authenticate_response.dart';

abstract class IAuthRepository {
  Future<void> authenticate(String accessToken, String refreshToken);
  Future<bool> isLoggedIn();
  Future<bool> logout();
  Future<bool> refreshToken();
  Future<AuthenticateResponse> authenticateWithKakao(
    AuthenticateRequest request,
  );
}

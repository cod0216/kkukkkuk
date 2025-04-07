import 'package:kkuk_kkuk/features/auth/api/dto/authenticate_request.dart';
import 'package:kkuk_kkuk/features/auth/api/dto/authenticate_response.dart';
import 'package:kkuk_kkuk/features/auth/api/dto/logout_response.dart';

abstract class IAuthRepository {
  Future<void> authenticate(String accessToken, String refreshToken);
  Future<bool> isLoggedIn();
  Future<LogoutResponse> logout();
  Future<AuthenticateResponse> authenticateWithKakao(
    AuthenticateRequest request,
  );
}

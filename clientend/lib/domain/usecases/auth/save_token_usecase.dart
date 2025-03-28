import 'package:kkuk_kkuk/domain/repositories/auth/token_repository_interface.dart';

class SaveTokensUseCase {
  final ITokenRepository _repository;

  SaveTokensUseCase(this._repository);

  Future<void> execute(String accessToken, String refreshToken) async {
    await _repository.saveAccessToken(accessToken);
    await _repository.saveRefreshToken(refreshToken);
  }
}

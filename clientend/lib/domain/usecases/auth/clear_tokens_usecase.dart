import 'package:kkuk_kkuk/domain/repositories/auth/token_repository_interface.dart';

class ClearTokensUseCase {
  final ITokenRepository _repository;

  ClearTokensUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearTokens();
  }
}

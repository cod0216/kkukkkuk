import 'package:kkuk_kkuk/features/auth/api/interfaces/token_repository_interface.dart';

class ClearTokensUseCase {
  final ITokenRepository _repository;

  ClearTokensUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearTokens();
  }
}

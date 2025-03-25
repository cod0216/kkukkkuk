import 'package:kkuk_kkuk/domain/repositories/token_repository_interface.dart';

class GetRefreshTokenUseCase {
  final ITokenRepository _repository;

  GetRefreshTokenUseCase(this._repository);

  Future<String?> execute() async {
    return await _repository.getRefreshToken();
  }
}

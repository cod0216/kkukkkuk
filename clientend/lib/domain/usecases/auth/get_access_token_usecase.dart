import 'package:kkuk_kkuk/domain/repositories/token_repository_interface.dart';

class GetAccessTokenUseCase {
  final ITokenRepository _repository;

  GetAccessTokenUseCase(this._repository);

  Future<String?> execute() async {
    return await _repository.getAccessToken();
  }
}

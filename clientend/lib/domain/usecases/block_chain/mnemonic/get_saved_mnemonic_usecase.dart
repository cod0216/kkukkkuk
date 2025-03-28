import 'package:kkuk_kkuk/domain/repositories/blockchain/mnemonic_repository_interface.dart';

class GetSavedMnemonicUseCase {
  final MnemonicRepositoryInterface _repository;

  GetSavedMnemonicUseCase(this._repository);

  Future<String?> execute() async {
    try {
      return await _repository.getSavedMnemonic();
    } catch (e) {
      print('GetSavedMnemonicUseCase.execute Error: $e');
      rethrow;
    }
  }
}

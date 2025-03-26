import 'package:kkuk_kkuk/domain/repositories/mnemonic_repository_interface.dart';

class SaveMnemonicUseCase {
  final MnemonicRepositoryInterface _repository;

  SaveMnemonicUseCase(this._repository);

  Future<void> execute(String mnemonic) async {
    try {
      await _repository.saveMnemonic(mnemonic);
    } catch (e) {
      print('SaveMnemonicUseCase.execute Error: $e');
      rethrow;
    }
  }
}

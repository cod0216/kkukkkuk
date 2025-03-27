import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/domain/repositories/mnemonic_repository_interface.dart';

class MnemonicRepository implements MnemonicRepositoryInterface {
  final FlutterSecureStorage _secureStorage;
  static const String _mnemonicKey = 'mnemonic_key';

  MnemonicRepository() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveMnemonic(String mnemonic) async {
    try {
      await _secureStorage.write(key: _mnemonicKey, value: mnemonic);
    } catch (e) {
      print('MnemonicRepository.saveMnemonic Error: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getSavedMnemonic() async {
    try {
      return await _secureStorage.read(key: _mnemonicKey);
    } catch (e) {
      print('MnemonicRepository.getSavedMnemonic Error: $e');
      rethrow;
    }
  }
}

final mnemonicRepositoryProvider = Provider<MnemonicRepository>((ref) {
  return MnemonicRepository();
});

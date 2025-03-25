import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GenerateKoreanMnemonicUseCase {
  final FlutterSecureStorage _secureStorage;
  static const String _mnemonicKey = 'mnemonic_key';

  GenerateKoreanMnemonicUseCase()
    : _secureStorage = const FlutterSecureStorage();

  /// 니모닉 단어 생성 (기본 12단어)
  Future<List<String>> execute({int strength = 128}) async {
    try {
      // 니모닉 생성
      final mnemonic = Mnemonic.generate(
        Language.korean,
        passphrase: "",
        entropyLength: strength,
      );

      // 니모닉을 안전하게 저장 (실제 앱에서는 사용자가 직접 백업하도록 안내)
      await _secureStorage.write(key: _mnemonicKey, value: mnemonic.sentence);

      print(mnemonic.sentence);
      // 니모닉 단어 목록 반환
      return mnemonic.sentence.split(' ');
    } catch (e) {
      throw Exception('니모닉 생성에 실패했습니다: $e');
    }
  }

  /// 저장된 니모닉 가져오기
  Future<String?> getSavedMnemonic() async {
    try {
      return await _secureStorage.read(key: _mnemonicKey);
    } catch (e) {
      throw Exception('저장된 니모닉을 가져오는데 실패했습니다: $e');
    }
  }
}

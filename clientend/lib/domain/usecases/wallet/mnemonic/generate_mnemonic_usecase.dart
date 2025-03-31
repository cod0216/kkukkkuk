import 'package:bip39_mnemonic/bip39_mnemonic.dart';

class GenerateMnemonicUseCase {
  /// 니모닉 단어 생성 (기본 12단어)
  Future<List<String>> execute({int strength = 128}) async {
    try {
      // 니모닉 생성
      final mnemonic = Mnemonic.generate(
        Language.english,
        passphrase: "",
        entropyLength: strength,
      );

      // 단어 리스트 반환
      return mnemonic.sentence.split(' ');
    } catch (e) {
      print('GenerateKoreanMnemonicUseCase.execute Error: $e');
      rethrow;
    }
  }
}

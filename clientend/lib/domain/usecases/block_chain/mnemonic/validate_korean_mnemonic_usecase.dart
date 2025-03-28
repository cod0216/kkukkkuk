import 'package:bip39_mnemonic/bip39_mnemonic.dart';

class ValidateKoreanMnemonicUseCase {
  bool execute(String sentence) {
    try {
      Mnemonic.fromSentence(sentence, Language.english);
      return true;
    } catch (e) {
      print('ValidateKoreanMnemonicUseCase.execute: $e');
      return false;
    }
  }
}

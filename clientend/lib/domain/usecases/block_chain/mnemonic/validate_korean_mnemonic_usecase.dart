import 'package:bip39_mnemonic/bip39_mnemonic.dart';

class ValidateKoreanMnemonicUseCase {
  bool execute(String sentence) {
    try {
      Mnemonic.fromSentence(sentence, Language.korean);
      return true;
    } catch (e) {
      print('ValidateKoreanMnemonicUseCase.execute: $e');
      return false;
    }
  }
}

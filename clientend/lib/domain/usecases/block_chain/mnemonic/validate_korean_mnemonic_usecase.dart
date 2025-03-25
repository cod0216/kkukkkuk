import 'package:bip39_mnemonic/bip39_mnemonic.dart';

class ValidateKoreanMnemonicUseCase {
  bool execute(String sentence) {
    try {
      Mnemonic.fromSentence(sentence, Language.korean);
      print('Mnemonic is valid');
      return true;
    } catch (e) {
      print('Mnemonic is invalid: $e');
      return false;
    }
  }
}

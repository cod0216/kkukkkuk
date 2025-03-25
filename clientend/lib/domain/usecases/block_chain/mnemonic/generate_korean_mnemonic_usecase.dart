import 'package:bip39_mnemonic/bip39_mnemonic.dart';

class GenerateKoreanMnemonicUseCase {
  Mnemonic execute({String? passphrase, int entropyLength = 256}) {
    return Mnemonic.generate(
      Language.korean,
      passphrase: passphrase ?? '',
      entropyLength: entropyLength,
    );
  }
}
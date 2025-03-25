import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:web3dart/web3dart.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip39/bip39.dart' as bip39;

class MnemonicUtils {
  // 한국어 니모닉 생성
  static Mnemonic generateKoreanMnemonic({
    String? passphrase,
    int entropyLength = 256,
  }) {
    return Mnemonic.generate(
      Language.korean,
      passphrase: passphrase ?? '',
      entropyLength: entropyLength,
    );
  }

  // 니모닉 문장 유효성 검증
  static bool validateMnemonic(String sentence) {
    try {
      Mnemonic.fromSentence(sentence, Language.korean);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 니모닉에서 개인 키 생성
  static EthPrivateKey privateKeyFromMnemonic(Mnemonic mnemonic) {
    String seedHex = bip39.mnemonicToSeedHex(mnemonic.sentence);

    // BIP-44 derivation path for Ethereum: m/44'/60'/0'/0/0
    Chain chain = Chain.seed(seedHex);
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");

    return EthPrivateKey.fromHex(key.privateKeyHex());
  }

  // 니모닉 문장에서 직접 개인 키 생성
  static EthPrivateKey privateKeyFromSentence(
    String sentence, {
    String? passphrase,
  }) {
    final mnemonic = Mnemonic.fromSentence(
      sentence,
      Language.korean,
      passphrase: passphrase ?? '',
    );
    return privateKeyFromMnemonic(mnemonic);
  }
}

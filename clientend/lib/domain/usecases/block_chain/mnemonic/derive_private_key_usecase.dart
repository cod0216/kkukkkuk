import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:web3dart/web3dart.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip39/bip39.dart' as bip39;

class DerivePrivateKeyUseCase {
  EthPrivateKey execute(Mnemonic mnemonic) {
    String seedHex = bip39.mnemonicToSeedHex(mnemonic.sentence);

    // BIP-44 derivation path for Ethereum: m/44'/60'/0'/0/0
    Chain chain = Chain.seed(seedHex);
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");

    return EthPrivateKey.fromHex(key.privateKeyHex());
  }
}
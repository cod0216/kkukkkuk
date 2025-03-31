import 'package:bip39/bip39.dart' as bip39;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class CreateWalletFromMnemonicUseCase {
  final FlutterSecureStorage _secureStorage;
  static const String _privateKeyKey = 'eth_private_key';
  static const String _addressKey = 'eth_address';
  static const String _publicKeyKey = 'eth_public_key';
  static const String _mnemonicKey = 'eth_mnemonic';

  CreateWalletFromMnemonicUseCase()
    : _secureStorage = const FlutterSecureStorage();

  /// 니모닉에서 HD 지갑 생성
  /// BIP44 경로를 사용하여 이더리움 지갑 생성 (m/44'/60'/0'/0/{accountIndex})
  Future<Map<String, String>> execute(
    String mnemonic, {
    int accountIndex = 0,
  }) async {
    try {
      // 니모닉에서 시드 생성
      final seedHex = bip39.mnemonicToSeedHex(mnemonic);
      print("seedHex: $seedHex");
      // Chain 객체 생성 및 BIP44 경로 사용
      final chain = Chain.seed(seedHex);
      final derivationPath = "m/44'/60'/0'/0/$accountIndex";
      print("derivationPath: $derivationPath");
      try {
        final extendedKey = chain.forPath(derivationPath);
        print("extendedKey: $extendedKey");
        // 개인키 및 주소 생성
        final privateKeyHex = extendedKey.privateKeyHex();
        print("privateKeyHex: $privateKeyHex");
        final credentials = EthPrivateKey.fromHex(privateKeyHex);
        final address = credentials.address.hexEip55;
        print("address: $address");

        // 공개키 생성
        final publicKeyBytes = credentials.encodedPublicKey;
        print("publicKeyBytes: $publicKeyBytes");
        final publicKey = '0x${bytesToHex(publicKeyBytes)}';
        print("publicKey: $publicKey");

        // DID 생성
        final did = _generateDid(address);
        print("did: $did");

        // 저장
        await _secureStorage.write(key: _privateKeyKey, value: privateKeyHex);
        await _secureStorage.write(key: _addressKey, value: address);
        await _secureStorage.write(key: _publicKeyKey, value: publicKey);
        await _secureStorage.write(key: _mnemonicKey, value: mnemonic);

        return {
          'privateKey': privateKeyHex,
          'address': address,
          'did': did,
          'publicKey': publicKey,
        };
      } on KeyZero catch (_) {
        throw Exception('키 생성 실패: 제로 키가 생성되었습니다.');
      } on KeyBiggerThanOrder catch (_) {
        throw Exception('키 생성 실패: 키가 허용된 범위를 초과했습니다.');
      } on KeyInfinite catch (_) {
        throw Exception('키 생성 실패: 무한대 키가 생성되었습니다.');
      }
    } catch (e) {
      throw Exception('HD 지갑 생성에 실패했습니다: $e');
    }
  }

  /// 저장된 지갑 정보 가져오기
  Future<Map<String, String?>> getSavedWalletInfo() async {
    try {
      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final address = await _secureStorage.read(key: _addressKey);
      final publicKey = await _secureStorage.read(key: _publicKeyKey);
      final mnemonic = await _secureStorage.read(key: _mnemonicKey);

      return {
        'privateKey': privateKey,
        'address': address,
        'publicKey': publicKey,
        'mnemonic': mnemonic,
        'did': address != null ? _generateDid(address) : null,
      };
    } catch (e) {
      throw Exception('저장된 지갑 정보를 가져오는데 실패했습니다: $e');
    }
  }

  String _generateDid(String address) {
    return 'did:guardian:$address';
  }
}

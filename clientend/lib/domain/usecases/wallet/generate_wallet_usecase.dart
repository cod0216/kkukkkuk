import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class GenerateWalletUseCase {
  final FlutterSecureStorage _secureStorage;
  static const String _privateKeyKey = 'eth_private_key';
  static const String _addressKey = 'eth_address';
  static const String _publicKeyKey = 'eth_public_key';

  GenerateWalletUseCase() : _secureStorage = const FlutterSecureStorage();

  Future<Map<String, String>> execute() async {
    try {
      // 개인키 생성
      final rng = Random.secure();
      final privateKeyBytes = List<int>.generate(32, (i) => rng.nextInt(256));
      final credentials = EthPrivateKey.fromHex(bytesToHex(privateKeyBytes));

      // 개인키와 주소 추출
      final privateKeyHex = bytesToHex(credentials.privateKey);
      final address = credentials.address.hexEip55;

      // 공개키 생성
      final publicKey = await _generatePublicKey(credentials);

      // DID 생성
      final did = _generateDid(address);

      // 저장
      await _secureStorage.write(key: _privateKeyKey, value: privateKeyHex);
      await _secureStorage.write(key: _addressKey, value: address);
      await _secureStorage.write(key: _publicKeyKey, value: publicKey);

      return {
        'privateKey': privateKeyHex,
        'address': address,
        'did': did,
        'publicKey': publicKey,
      };
    } catch (e) {
      throw Exception('지갑 생성에 실패했습니다: $e');
    }
  }

  Future<String> _generatePublicKey(EthPrivateKey credentials) async {
    try {
      final publicKeyBytes = credentials.encodedPublicKey;
      return '0x${bytesToHex(publicKeyBytes)}';
    } catch (e) {
      throw Exception('공개키 생성에 실패했습니다: $e');
    }
  }

  String _generateDid(String address) {
    return 'did:guardian:$address';
  }
}
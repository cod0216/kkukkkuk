import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';

/// 블록체인 지갑 관련 서비스
class WalletService {
  // TODO: 실제 블록체인 네트워크 연동
  // TODO: 보안 라이브러리 적용
  // TODO: 트랜잭션 서명 구현
  // TODO: 에러 처리 개선
  final FlutterSecureStorage _secureStorage;
  static const String _privateKeyKey = 'eth_private_key';
  static const String _addressKey = 'eth_address';
  static const String _publicKeyKey = 'eth_public_key';

  WalletService() : _secureStorage = const FlutterSecureStorage();

  /// 새 지갑 생성
  Future<Map<String, String>> createWallet() async {
    try {
      // 개인키 생성
      final rng = Random.secure();
      final privateKeyBytes = List<int>.generate(32, (i) => rng.nextInt(256));
      final credentials = EthPrivateKey.fromHex(bytesToHex(privateKeyBytes));

      // 개인키와 주소 추출
      final privateKeyHex = bytesToHex(credentials.privateKey);
      final address = credentials.address.hexEip55;

      // 공개키 생성
      final publicKey = await generatePublicKey(credentials);

      // DID 생성
      final did = generateDid(address);

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

  /// 개인키로부터 공개키 생성
  Future<String> generatePublicKey(EthPrivateKey credentials) async {
    try {
      // SECP256K1 곡선의 공개키 포인트 계산
      final publicKeyBytes = credentials.encodedPublicKey;

      // 공개키를 16진수 문자열로 변환 (0x 접두사 추가)
      return '0x${bytesToHex(publicKeyBytes)}';
    } catch (e) {
      throw Exception('공개키 생성에 실패했습니다: $e');
    }
  }

  /// 지갑 주소로부터 DID 생성
  String generateDid(String address) {
    return 'did:guardian:$address';
  }

  /// 서버에서 지갑 정보 조회
  Future<Map<String, dynamic>?> getWallet() async {
    try {
      // TODO: 실제 서버에서 지갑 정보 조회 구현
      await Future.delayed(const Duration(seconds: 1));

      return {
        'address': '0x123...abc',
        'encryptedPrivateKey': 'encrypted_private_key_data',
        'createdAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('지갑 정보 조회에 실패했습니다: $e');
    }
  }

  /// 서버에서 지갑 삭제
  Future<bool> deleteWallet() async {
    try {
      // TODO: 실제 서버에서 지갑 삭제 구현
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('지갑 삭제에 실패했습니다: $e');
    }
  }

  /// 개인키로 지갑 복구
  Future<Map<String, String>> recoverWalletFromPrivateKey(
    String privateKey,
  ) async {
    try {
      // TODO: 실제 개인키를 이용한 지갑 복구 구현
      await Future.delayed(const Duration(seconds: 1));
      return {'privateKey': privateKey, 'address': '0x123...recovered'};
    } catch (e) {
      throw Exception('지갑 복구에 실패했습니다: $e');
    }
  }

  /// PIN으로 개인키 암호화
  Future<String> encryptPrivateKey(String privateKey, String pin) async {
    try {
      // PIN을 32바이트 키로 확장
      final key = Key.fromUtf8(pin.padRight(32, '0'));
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key));

      // 개인키 암호화
      final encrypted = encrypter.encrypt(privateKey, iv: iv);

      // IV와 암호문을 함께 base64로 인코딩
      final combined = json.encode({
        'iv': base64.encode(iv.bytes),
        'encrypted': encrypted.base64,
      });

      return combined;
    } catch (e) {
      throw Exception('개인키 암호화에 실패했습니다: $e');
    }
  }

  /// PIN으로 개인키 복호화
  Future<String?> decryptPrivateKey(
    String encryptedPrivateKey,
    String pin,
  ) async {
    try {
      final Map<String, dynamic> parts = json.decode(encryptedPrivateKey);

      // PIN을 32바이트 키로 확장
      final key = Key.fromUtf8(pin.padRight(32, '0'));
      final iv = IV.fromBase64(parts['iv']);
      final encrypter = Encrypter(AES(key));

      // 복호화
      final decrypted = encrypter.decrypt64(parts['encrypted'], iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception('개인키 복호화에 실패했습니다: $e');
    }
  }

  /// 암호화된 지갑 정보를 서버에 저장
  Future<bool> saveEncryptedWallet(
    String walletAddress,
    String encryptedPrivateKey,
  ) async {
    try {
      // TODO: 실제 서버에 암호화된 지갑 정보 저장 구현
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('암호화된 지갑 저장에 실패했습니다: $e');
    }
  }

  /// 사용자의 지갑 존재 여부 확인
  Future<bool> checkWalletExists() async {
    try {
      // TODO: 실제 서버에서 지갑 존재 여부 확인 구현
      await Future.delayed(const Duration(seconds: 1));
      return false;
    } catch (e) {
      throw Exception('지갑 존재 여부 확인에 실패했습니다: $e');
    }
  }
}

/// 지갑 서비스 프로바이더
final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

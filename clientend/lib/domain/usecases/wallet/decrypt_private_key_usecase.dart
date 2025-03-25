import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class DecryptPrivateKeyUseCase {
  Future<String?> execute(String encryptedPrivateKey, String pin) async {
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
}
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptPrivateKeyUseCase {
  Future<String> execute(String privateKey, String pin) async {
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

      return combined.toString();
    } catch (e) {
      throw Exception('개인키 암호화에 실패했습니다: $e');
    }
  }
}
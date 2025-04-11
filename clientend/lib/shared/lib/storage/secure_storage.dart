import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  // 데이터 저장
  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // 데이터 조회
  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  // 데이터 삭제
  Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  // 모든 데이터 삭제
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // 특정 키가 존재하는지 확인
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  // 저장된 모든 키 조회
  Future<Map<String, String>> getAll() async {
    return await _storage.readAll();
  }
}

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

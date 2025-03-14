import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 사용자 관련 서비스
class UserService {
  // TODO: API 엔드포인트 설정
  // TODO: 토큰 관리 구현
  // TODO: 캐싱 구현
  // TODO: 에러 처리 개선
  // TODO: 데이터 유효성 검사 추가

  /// 사용자 프로필 정보 조회
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      // TODO: 실제 서버에서 사용자 프로필 정보 조회 구현
      await Future.delayed(const Duration(seconds: 1));

      return {
        'id': 1,
        'name': '김꾹꾹',
        'email': 'user@example.com',
        'phoneNumber': '010-1234-5678',
        'profileImageUrl': 'https://example.com/profile.jpg',
        'createdAt':
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      };
    } catch (e) {
      throw Exception('사용자 정보를 불러오는데 실패했습니다: $e');
    }
  }

  /// 사용자 프로필 정보 수정
  Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      // TODO: 실제 서버에 사용자 프로필 정보 업데이트 구현
      await Future.delayed(const Duration(seconds: 1));

      return {
        'id': 1,
        'name': name,
        'email': email ?? 'user@example.com',
        'phoneNumber': phoneNumber ?? '010-1234-5678',
        'profileImageUrl': 'https://example.com/profile.jpg',
        'createdAt':
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('사용자 정보 수정에 실패했습니다: $e');
    }
  }

  /// 프로필 이미지 업데이트
  Future<String> updateProfileImage(String imagePath) async {
    try {
      // TODO: 실제 서버에 프로필 이미지 업로드 구현
      await Future.delayed(const Duration(seconds: 2));

      return 'https://example.com/new-profile.jpg';
    } catch (e) {
      throw Exception('프로필 이미지 업데이트에 실패했습니다: $e');
    }
  }

  /// 계정 삭제
  Future<bool> deleteUserAccount() async {
    try {
      // TODO: 실제 서버에서 사용자 계정 삭제 구현
      await Future.delayed(const Duration(seconds: 2));

      return true;
    } catch (e) {
      throw Exception('계정 삭제에 실패했습니다: $e');
    }
  }
}

/// 사용자 서비스 프로바이더
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

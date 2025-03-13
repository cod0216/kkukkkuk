import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserService {
  // Get user profile information
  Future<Map<String, dynamic>> getUserProfile() async {
    // TODO: Implement actual user profile retrieval from server
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
  }

  // Update user profile information
  Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    String? email,
    String? phoneNumber,
  }) async {
    // TODO: Implement actual user profile update to server
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
  }

  // Update user profile image
  Future<String> updateProfileImage(String imagePath) async {
    // TODO: Implement actual profile image upload to server
    await Future.delayed(const Duration(seconds: 2));

    // Return the URL of the uploaded image
    return 'https://example.com/new-profile.jpg';
  }

  // Delete user account
  Future<bool> deleteUserAccount() async {
    // TODO: Implement actual user account deletion on server
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

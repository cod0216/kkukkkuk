import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:kkuk_kkuk/shared/api/client/api_client.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_profile_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_withdrawal_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_update_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_image_upload_response.dart';
import 'package:kkuk_kkuk/features/user/api/repositories/user_repository_interface.dart';

class UserRepository implements IUserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  @override
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _apiClient.get('/api/owners/me');
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      print('사용자 프로필 조회 실패: $e');
      rethrow;
    }
  }

  @override
  Future<UserWithdrawalResponse> withdrawUser() async {
    try {
      final response = await _apiClient.delete('/api/owners/me');
      return UserWithdrawalResponse.fromJson(response.data);
    } catch (e) {
      print('회원 탈퇴 실패: $e');
      rethrow;
    }
  }

  @override
  Future<UserUpdateResponse> updateUser({String? name, String? birth}) async {
    try {
      final data = {
        if (name != null) 'name': name,
        if (birth != null) 'birth': birth,
      };

      final response = await _apiClient.patch('/api/owners/me', data: data);
      return UserUpdateResponse.fromJson(response.data);
    } catch (e) {
      print('사용자 정보 업데이트 실패: $e');
      rethrow;
    }
  }

  @override
  Future<UserImageUploadResponse> uploadProfileImage(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await _apiClient.multipartPost(
        '/api/owners/me/images',
        data: formData,
      );

      // 응답 처리
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('서버 응답이 없습니다.');
        }

        // Create a UserImageUploadResponse with the string data
        return UserImageUploadResponse(
          status: 'SUCCESS',
          message: '프로필 이미지 업로드 성공',
          data: UserImageUploadData(image: response.data.toString()),
        );
      } else {
        throw Exception('이미지 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('프로필 이미지 업로드 실패: $e');
      rethrow;
    }
  }
}

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});

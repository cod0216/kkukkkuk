import 'dart:io';
import 'package:kkuk_kkuk/features/user/api/dto/user_profile_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_withdrawal_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_update_response.dart';
import 'package:kkuk_kkuk/features/user/api/dto/user_image_upload_response.dart';

abstract class IUserRepository {
  /// 현재 로그인한 사용자의 프로필 정보를 조회합니다.
  Future<UserProfileResponse> getUserProfile();

  /// 현재 로그인한 사용자의 회원 탈퇴를 처리합니다.
  Future<UserWithdrawalResponse> withdrawUser();

  /// 사용자 정보를 업데이트합니다.
  Future<UserUpdateResponse> updateUser({String? name, String? birth});

  /// 사용자 프로필 이미지를 업로드합니다.
  Future<UserImageUploadResponse> uploadProfileImage(File image);
}

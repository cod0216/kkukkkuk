import 'dart:io';
import 'package:kkuk_kkuk/data/dtos/user/user_image_upload_response.dart';
import 'package:kkuk_kkuk/domain/repositories/user/user_repository_interface.dart';

class UploadProfileImageUseCase {
  final IUserRepository _repository;

  UploadProfileImageUseCase(this._repository);

  Future<UserImageUploadResponse> execute(File image) async {
    try {
      return await _repository.uploadProfileImage(image);
    } catch (e) {
      print('프로필 이미지 업로드 실패: $e');
      rethrow;
    }
  }
}
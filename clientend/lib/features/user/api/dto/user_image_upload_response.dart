import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_image_upload_response.freezed.dart';
part 'user_image_upload_response.g.dart';

@freezed
abstract class UserImageUploadResponse with _$UserImageUploadResponse {
  const factory UserImageUploadResponse({
    required String status,
    required String message,
    required UserImageUploadData data,
  }) = _UserImageUploadResponse;

  factory UserImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UserImageUploadResponseFromJson(json);
}

@freezed
abstract class UserImageUploadData with _$UserImageUploadData {
  const factory UserImageUploadData({required String image}) =
      _UserImageUploadData;

  factory UserImageUploadData.fromJson(Map<String, dynamic> json) =>
      _$UserImageUploadDataFromJson(json);
}

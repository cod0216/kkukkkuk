import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_upload_response.freezed.dart';
part 'image_upload_response.g.dart';

/// 이미지 업로드 응답 DTO
@freezed
abstract class ImageUploadResponse with _$ImageUploadResponse {
  const factory ImageUploadResponse({required String data}) =
      _ImageUploadResponse;

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseFromJson(json);
}

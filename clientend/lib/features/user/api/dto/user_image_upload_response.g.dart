// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_image_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserImageUploadResponse _$UserImageUploadResponseFromJson(
  Map<String, dynamic> json,
) => _UserImageUploadResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: UserImageUploadData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserImageUploadResponseToJson(
  _UserImageUploadResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_UserImageUploadData _$UserImageUploadDataFromJson(Map<String, dynamic> json) =>
    _UserImageUploadData(image: json['image'] as String);

Map<String, dynamic> _$UserImageUploadDataToJson(
  _UserImageUploadData instance,
) => <String, dynamic>{'image': instance.image};

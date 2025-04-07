// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserUpdateResponse _$UserUpdateResponseFromJson(Map<String, dynamic> json) =>
    _UserUpdateResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: UserUpdateData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserUpdateResponseToJson(_UserUpdateResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_UserUpdateData _$UserUpdateDataFromJson(Map<String, dynamic> json) =>
    _UserUpdateData(
      id: (json['id'] as num).toInt(),
      did: json['did'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      birth: json['birth'] as String?,
    );

Map<String, dynamic> _$UserUpdateDataToJson(_UserUpdateData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'name': instance.name,
      'email': instance.email,
      'birth': instance.birth,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_delete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetDeleteResponse _$PetDeleteResponseFromJson(Map<String, dynamic> json) =>
    _PetDeleteResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$PetDeleteResponseToJson(_PetDeleteResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

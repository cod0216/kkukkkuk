// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    _ErrorResponse(
      name: json['name'] as String,
      code: json['code'] as String,
      message: json['message'] as String,
      status: json['status'] as String,
      httpCode: (json['http_code'] as num).toInt(),
    );

Map<String, dynamic> _$ErrorResponseToJson(_ErrorResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
      'http_code': instance.httpCode,
    };

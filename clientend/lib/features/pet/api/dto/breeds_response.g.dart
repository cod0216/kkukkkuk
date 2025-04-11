// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeds_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BreedsResponse _$BreedsResponseFromJson(Map<String, dynamic> json) =>
    _BreedsResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => Breed.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BreedsResponseToJson(_BreedsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

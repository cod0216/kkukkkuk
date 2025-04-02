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
              .map((e) => BreedsData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BreedsResponseToJson(_BreedsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_BreedsData _$BreedsDataFromJson(Map<String, dynamic> json) =>
    _BreedsData(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$BreedsDataToJson(_BreedsData instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

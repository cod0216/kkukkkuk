// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KakaoAuthRequest _$KakaoAuthRequestFromJson(Map<String, dynamic> json) =>
    _KakaoAuthRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      birthyear: json['birthyear'] as String,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      providerId: json['provider_id'] as String,
    );

Map<String, dynamic> _$KakaoAuthRequestToJson(_KakaoAuthRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'birthyear': instance.birthyear,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'provider_id': instance.providerId,
    };

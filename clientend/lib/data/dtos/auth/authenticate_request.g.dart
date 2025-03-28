// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticateRequest _$AuthenticateRequestFromJson(Map<String, dynamic> json) =>
    _AuthenticateRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      birthyear: json['birthyear'] as String,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      providerId: json['provider_id'] as String,
    );

Map<String, dynamic> _$AuthenticateRequestToJson(
  _AuthenticateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'birthyear': instance.birthyear,
  'birthday': instance.birthday,
  'gender': instance.gender,
  'provider_id': instance.providerId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerInfo _$OwnerInfoFromJson(Map<String, dynamic> json) => _OwnerInfo(
  id: (json['id'] as num).toInt(),
  did: json['did'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  birth: json['birth'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$OwnerInfoToJson(_OwnerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'name': instance.name,
      'email': instance.email,
      'birth': instance.birth,
      'image': instance.image,
    };

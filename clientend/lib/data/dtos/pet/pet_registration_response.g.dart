// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetRegistrationResponse _$PetRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _PetRegistrationResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data:
      json['data'] == null
          ? null
          : PetData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PetRegistrationResponseToJson(
  _PetRegistrationResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_PetData _$PetDataFromJson(Map<String, dynamic> json) => _PetData(
  id: (json['id'] as num).toInt(),
  did: json['did'] as String,
  name: json['name'] as String,
  gender: json['gender'] as String,
  breedId: (json['breed_id'] as num).toInt(),
  birth: json['birth'] as String?,
  flagNeutering: json['flag_neutering'] as bool,
);

Map<String, dynamic> _$PetDataToJson(_PetData instance) => <String, dynamic>{
  'id': instance.id,
  'did': instance.did,
  'name': instance.name,
  'gender': instance.gender,
  'breed_id': instance.breedId,
  'birth': instance.birth,
  'flag_neutering': instance.flagNeutering,
};

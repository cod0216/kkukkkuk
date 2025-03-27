// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetRegistrationRequest _$PetRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _PetRegistrationRequest(
  did: json['did'] as String,
  name: json['name'] as String,
  gender: json['gender'] as String,
  breedId: (json['breed_id'] as num).toInt(),
  birth: json['birth'] as String?,
  flagNeutering: json['flag_neutering'] as bool,
);

Map<String, dynamic> _$PetRegistrationRequestToJson(
  _PetRegistrationRequest instance,
) => <String, dynamic>{
  'did': instance.did,
  'name': instance.name,
  'gender': instance.gender,
  'breed_id': instance.breedId,
  'birth': instance.birth,
  'flag_neutering': instance.flagNeutering,
};

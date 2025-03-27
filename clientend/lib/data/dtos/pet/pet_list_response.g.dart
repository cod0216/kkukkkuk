// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetListResponse _$PetListResponseFromJson(Map<String, dynamic> json) =>
    _PetListResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => PetListData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PetListResponseToJson(_PetListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_PetListData _$PetListDataFromJson(Map<String, dynamic> json) => _PetListData(
  id: (json['id'] as num).toInt(),
  did: json['did'] as String,
  name: json['name'] as String,
  gender: json['gender'] as String,
  flagNeutering: json['flag_neutering'] as bool,
  breedId: (json['breed_id'] as num).toInt(),
  breedName: json['breed_name'] as String,
  birth: json['birth'] as String?,
  age: json['age'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$PetListDataToJson(_PetListData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'name': instance.name,
      'gender': instance.gender,
      'flag_neutering': instance.flagNeutering,
      'breed_id': instance.breedId,
      'breed_name': instance.breedName,
      'birth': instance.birth,
      'age': instance.age,
      'image': instance.image,
    };

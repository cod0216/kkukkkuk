// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    _UserProfileResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: UserProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
  _UserProfileResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    _UserProfileData(
      owner: OwnerProfileInfo.fromJson(json['owner'] as Map<String, dynamic>),
      wallets:
          (json['wallets'] as List<dynamic>?)
              ?.map(
                (e) => WalletProfileInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$UserProfileDataToJson(_UserProfileData instance) =>
    <String, dynamic>{'owner': instance.owner, 'wallets': instance.wallets};

_OwnerProfileInfo _$OwnerProfileInfoFromJson(Map<String, dynamic> json) =>
    _OwnerProfileInfo(
      id: (json['id'] as num).toInt(),
      did: json['did'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      birth: json['birth'] as String?,
    );

Map<String, dynamic> _$OwnerProfileInfoToJson(_OwnerProfileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'name': instance.name,
      'email': instance.email,
      'birth': instance.birth,
    };

_WalletProfileInfo _$WalletProfileInfoFromJson(Map<String, dynamic> json) =>
    _WalletProfileInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$WalletProfileInfoToJson(_WalletProfileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };

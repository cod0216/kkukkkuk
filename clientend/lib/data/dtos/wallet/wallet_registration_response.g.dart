// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletRegistrationResponse _$WalletRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _WalletRegistrationResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: WalletData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletRegistrationResponseToJson(
  _WalletRegistrationResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_WalletData _$WalletDataFromJson(Map<String, dynamic> json) => _WalletData(
  id: (json['id'] as num).toInt(),
  address: json['address'] as String,
  name: json['name'] as String?,
  owners:
      (json['owners'] as List<dynamic>)
          .map((e) => WalletOwner.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$WalletDataToJson(_WalletData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'name': instance.name,
      'owners': instance.owners,
    };

_WalletOwner _$WalletOwnerFromJson(Map<String, dynamic> json) => _WalletOwner(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$WalletOwnerToJson(_WalletOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

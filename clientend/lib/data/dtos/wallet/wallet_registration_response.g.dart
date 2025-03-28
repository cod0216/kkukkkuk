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
  did: json['did'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$WalletDataToJson(_WalletData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'address': instance.address,
    };

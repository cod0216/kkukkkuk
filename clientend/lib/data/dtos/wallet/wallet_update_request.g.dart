// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletUpdateRequest _$WalletUpdateRequestFromJson(Map<String, dynamic> json) =>
    _WalletUpdateRequest(
      did: json['did'] as String,
      address: json['address'] as String,
      publicKey: json['public_key'] as String,
    );

Map<String, dynamic> _$WalletUpdateRequestToJson(
  _WalletUpdateRequest instance,
) => <String, dynamic>{
  'did': instance.did,
  'address': instance.address,
  'public_key': instance.publicKey,
};

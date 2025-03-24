// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletRegistrationRequest _$WalletRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _WalletRegistrationRequest(
  did: json['did'] as String,
  address: json['address'] as String,
  privateKey: json['private_key'] as String,
  publicKey: json['public_key'] as String,
);

Map<String, dynamic> _$WalletRegistrationRequestToJson(
  _WalletRegistrationRequest instance,
) => <String, dynamic>{
  'did': instance.did,
  'address': instance.address,
  'private_key': instance.privateKey,
  'public_key': instance.publicKey,
};

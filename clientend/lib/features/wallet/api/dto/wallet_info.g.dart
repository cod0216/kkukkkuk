// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletInfo _$WalletInfoFromJson(Map<String, dynamic> json) => _WalletInfo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  address: json['address'] as String,
);

Map<String, dynamic> _$WalletInfoToJson(_WalletInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };

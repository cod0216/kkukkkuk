// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletInfoResponse _$WalletInfoResponseFromJson(Map<String, dynamic> json) =>
    _WalletInfoResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => WalletInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$WalletInfoResponseToJson(_WalletInfoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

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

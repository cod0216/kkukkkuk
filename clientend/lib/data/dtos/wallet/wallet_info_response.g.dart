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
          json['data'] == null
              ? null
              : WalletInfoData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletInfoResponseToJson(_WalletInfoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_WalletInfoData _$WalletInfoDataFromJson(Map<String, dynamic> json) =>
    _WalletInfoData(
      walletId: (json['wallet-id'] as num).toInt(),
      walletDid: json['wallet-did'] as String,
      walletAddress: json['wallet-address'] as String,
    );

Map<String, dynamic> _$WalletInfoDataToJson(_WalletInfoData instance) =>
    <String, dynamic>{
      'wallet-id': instance.walletId,
      'wallet-did': instance.walletDid,
      'wallet-address': instance.walletAddress,
    };

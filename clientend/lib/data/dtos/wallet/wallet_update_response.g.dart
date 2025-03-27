// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletUpdateResponse _$WalletUpdateResponseFromJson(
  Map<String, dynamic> json,
) => _WalletUpdateResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: WalletData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletUpdateResponseToJson(
  _WalletUpdateResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

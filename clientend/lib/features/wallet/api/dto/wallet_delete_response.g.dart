// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_delete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletDeleteResponse _$WalletDeleteResponseFromJson(
  Map<String, dynamic> json,
) => _WalletDeleteResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: json['data'],
);

Map<String, dynamic> _$WalletDeleteResponseToJson(
  _WalletDeleteResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

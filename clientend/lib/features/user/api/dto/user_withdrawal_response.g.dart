// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_withdrawal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserWithdrawalResponse _$UserWithdrawalResponseFromJson(
  Map<String, dynamic> json,
) => _UserWithdrawalResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: json['data'],
);

Map<String, dynamic> _$UserWithdrawalResponseToJson(
  _UserWithdrawalResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

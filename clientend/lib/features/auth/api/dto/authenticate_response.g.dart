// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticateResponse _$AuthenticateResponseFromJson(
  Map<String, dynamic> json,
) => _AuthenticateResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: AuthenticateData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthenticateResponseToJson(
  _AuthenticateResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_AuthenticateData _$AuthenticateDataFromJson(Map<String, dynamic> json) =>
    _AuthenticateData(
      owner: OwnerInfo.fromJson(json['owner'] as Map<String, dynamic>),
      tokens: TokenInfo.fromJson(json['tokens'] as Map<String, dynamic>),
      wallets:
          (json['wallets'] as List<dynamic>?)
              ?.map((e) => WalletInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AuthenticateDataToJson(_AuthenticateData instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'tokens': instance.tokens,
      'wallets': instance.wallets,
    };

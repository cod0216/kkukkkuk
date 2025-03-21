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
      wallet:
          json['wallet'] == null
              ? null
              : WalletInfo.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticateDataToJson(_AuthenticateData instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'tokens': instance.tokens,
      'wallet': instance.wallet,
    };

_OwnerInfo _$OwnerInfoFromJson(Map<String, dynamic> json) => _OwnerInfo(
  id: (json['id'] as num).toInt(),
  did: json['did'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$OwnerInfoToJson(_OwnerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'name': instance.name,
      'email': instance.email,
    };

_TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => _TokenInfo(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
);

Map<String, dynamic> _$TokenInfoToJson(_TokenInfo instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

_WalletInfo _$WalletInfoFromJson(Map<String, dynamic> json) => _WalletInfo(
  id: (json['id'] as num).toInt(),
  did: json['did'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$WalletInfoToJson(_WalletInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'did': instance.did,
      'address': instance.address,
    };

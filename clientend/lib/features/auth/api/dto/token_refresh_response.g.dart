// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_refresh_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenRefreshResponse _$TokenRefreshResponseFromJson(
  Map<String, dynamic> json,
) => _TokenRefreshResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: TokenRefreshData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TokenRefreshResponseToJson(
  _TokenRefreshResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_TokenRefreshData _$TokenRefreshDataFromJson(Map<String, dynamic> json) =>
    _TokenRefreshData(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$TokenRefreshDataToJson(_TokenRefreshData instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'authenticate_response.freezed.dart';
part 'authenticate_response.g.dart';

@freezed
abstract class AuthenticateResponse with _$AuthenticateResponse {
  const factory AuthenticateResponse({
    required String status,
    required String message,
    required AuthenticateData data,
  }) = _AuthenticateResponse;

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateResponseFromJson(json);
}

@freezed
abstract class AuthenticateData with _$AuthenticateData {
  const factory AuthenticateData({
    required OwnerInfo owner,
    required TokenInfo tokens,
    List<WalletInfo>? wallets,
  }) = _AuthenticateData;

  factory AuthenticateData.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateDataFromJson(json);
}

@freezed
abstract class OwnerInfo with _$OwnerInfo {
  const factory OwnerInfo({
    required int id,
    String? did,
    required String name,
    required String email,
    String? birth,
    String? image,
  }) = _OwnerInfo;

  factory OwnerInfo.fromJson(Map<String, dynamic> json) =>
      _$OwnerInfoFromJson(json);
}

@freezed
abstract class TokenInfo with _$TokenInfo {
  const factory TokenInfo({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);
}

@freezed
abstract class WalletInfo with _$WalletInfo {
  const factory WalletInfo({
    required int id,
    String? name,
    required String address,
  }) = _WalletInfo;

  factory WalletInfo.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoFromJson(json);
}

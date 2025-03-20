import 'package:freezed_annotation/freezed_annotation.dart';

part 'kakao_auth_response.freezed.dart';
part 'kakao_auth_response.g.dart';

@freezed
abstract class KakaoAuthResponse with _$KakaoAuthResponse {
  const factory KakaoAuthResponse({
    required String status,
    required String message,
    required KakaoAuthData data,
  }) = _KakaoAuthResponse;

  factory KakaoAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthResponseFromJson(json);
}

@freezed
abstract class KakaoAuthData with _$KakaoAuthData {
  const factory KakaoAuthData({
    required OwnerInfo owner,
    required TokenInfo tokens,
    WalletInfo? wallet,
  }) = _KakaoAuthData;

  factory KakaoAuthData.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthDataFromJson(json);
}

@freezed
abstract class OwnerInfo with _$OwnerInfo {
  const factory OwnerInfo({
    required int id,
    String? did,
    required String name,
    required String email,
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
    required String did,
    required String address,
  }) = _WalletInfo;

  factory WalletInfo.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoFromJson(json);
}

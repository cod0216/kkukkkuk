import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_response.freezed.dart';
part 'user_profile_response.g.dart';

@freezed
abstract class UserProfileResponse with _$UserProfileResponse {
  const factory UserProfileResponse({
    required String status,
    required String message,
    required UserProfileData data,
  }) = _UserProfileResponse;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);
}

@freezed
abstract class UserProfileData with _$UserProfileData {
  const factory UserProfileData({
    required OwnerProfileInfo owner,
    WalletProfileInfo? wallet,
  }) = _UserProfileData;

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDataFromJson(json);
}

@freezed
abstract class OwnerProfileInfo with _$OwnerProfileInfo {
  const factory OwnerProfileInfo({
    required int id,
    String? did,
    required String name,
    required String email,
    String? birth,
  }) = _OwnerProfileInfo;

  factory OwnerProfileInfo.fromJson(Map<String, dynamic> json) =>
      _$OwnerProfileInfoFromJson(json);
}

@freezed
abstract class WalletProfileInfo with _$WalletProfileInfo {
  const factory WalletProfileInfo({
    required int id,
    required String did,
    required String address,
  }) = _WalletProfileInfo;

  factory WalletProfileInfo.fromJson(Map<String, dynamic> json) =>
      _$WalletProfileInfoFromJson(json);
}
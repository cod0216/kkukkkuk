import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_info_response.freezed.dart';
part 'wallet_info_response.g.dart';

/// 지갑 조회 응답 DTO
@freezed
abstract class WalletInfoResponse with _$WalletInfoResponse {
  const factory WalletInfoResponse({
    required String status,
    required String message,
    WalletInfoData? data,
  }) = _WalletInfoResponse;

  factory WalletInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoResponseFromJson(json);
}

/// 지갑 정보 데이터 DTO
@freezed
abstract class WalletInfoData with _$WalletInfoData {
  const factory WalletInfoData({
    @JsonKey(name: 'wallet-id') required int walletId,
    @JsonKey(name: 'wallet-did') required String walletDid,
    @JsonKey(name: 'wallet-address') required String walletAddress,
  }) = _WalletInfoData;

  factory WalletInfoData.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoDataFromJson(json);
}
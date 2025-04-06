import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_info_response.freezed.dart';
part 'wallet_info_response.g.dart';

/// 지갑 조회 응답 DTO
@freezed
abstract class WalletInfoResponse with _$WalletInfoResponse {
  const factory WalletInfoResponse({
    required String status,
    required String message,
    required List<WalletInfo> data,
  }) = _WalletInfoResponse;

  factory WalletInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoResponseFromJson(json);
}

/// 지갑 정보 데이터 DTO
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

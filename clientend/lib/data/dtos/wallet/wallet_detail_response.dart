import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_detail_response.freezed.dart';
part 'wallet_detail_response.g.dart';

/// 지갑 상세 조회 응답 DTO
@freezed
abstract class WalletDetailResponse with _$WalletDetailResponse {
  const factory WalletDetailResponse({
    required String status,
    required String message,
    required WalletDetailData data,
  }) = _WalletDetailResponse;

  factory WalletDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletDetailResponseFromJson(json);
}

/// 지갑 상세 데이터 DTO
@freezed
abstract class WalletDetailData with _$WalletDetailData {
  const factory WalletDetailData({
    required int id,
    required String address,
    required String name,
    required List<WalletOwner> owners,
  }) = _WalletDetailData;

  factory WalletDetailData.fromJson(Map<String, dynamic> json) =>
      _$WalletDetailDataFromJson(json);
}

/// 지갑 소유자 정보 DTO
@freezed
abstract class WalletOwner with _$WalletOwner {
  const factory WalletOwner({
    required int id,
    required String name,
    String? image,
  }) = _WalletOwner;

  factory WalletOwner.fromJson(Map<String, dynamic> json) =>
      _$WalletOwnerFromJson(json);
}

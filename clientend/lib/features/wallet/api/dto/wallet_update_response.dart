import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_update_response.freezed.dart';
part 'wallet_update_response.g.dart';

/// 지갑 업데이트 응답 DTO
@freezed
abstract class WalletUpdateResponse with _$WalletUpdateResponse {
  const factory WalletUpdateResponse({
    required String status,
    required String message,
    required WalletData data,
  }) = _WalletUpdateResponse;

  factory WalletUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletUpdateResponseFromJson(json);
}

/// 지갑 데이터 DTO
@freezed
abstract class WalletData with _$WalletData {
  const factory WalletData({
    required int id,
    required String address,
    required String name,
    required List<WalletOwner> owners,
  }) = _WalletData;

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);
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

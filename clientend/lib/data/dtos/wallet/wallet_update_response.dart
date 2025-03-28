import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';

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
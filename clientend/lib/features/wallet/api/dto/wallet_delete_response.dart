import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_delete_response.freezed.dart';
part 'wallet_delete_response.g.dart';

/// 지갑 삭제 응답 DTO
@freezed
abstract class WalletDeleteResponse with _$WalletDeleteResponse {
  const factory WalletDeleteResponse({
    required String status,
    required String message,
    dynamic data,
  }) = _WalletDeleteResponse;

  factory WalletDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletDeleteResponseFromJson(json);
}

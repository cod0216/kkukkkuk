import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_update_request.freezed.dart';
part 'wallet_update_request.g.dart';

/// 지갑 업데이트 요청 DTO
@freezed
abstract class WalletUpdateRequest with _$WalletUpdateRequest {
  const factory WalletUpdateRequest({required String name}) =
      _WalletUpdateRequest;

  factory WalletUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletUpdateRequestFromJson(json);
}

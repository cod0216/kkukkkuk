import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_registration_request.freezed.dart';
part 'wallet_registration_request.g.dart';

/// 지갑 등록 요청 DTO
@freezed
abstract class WalletRegistrationRequest with _$WalletRegistrationRequest {
  const factory WalletRegistrationRequest({
    required String name,
    required String address,
  }) = _WalletRegistrationRequest;

  factory WalletRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletRegistrationRequestFromJson(json);
}

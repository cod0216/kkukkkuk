import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_registration_request.freezed.dart';
part 'wallet_registration_request.g.dart';

/// 지갑 등록 요청 DTO
@freezed
abstract class WalletRegistrationRequest with _$WalletRegistrationRequest {
  const factory WalletRegistrationRequest({
    required String did,
    required String address,
    @JsonKey(name: 'private_key') required String privateKey,
    @JsonKey(name: 'public_key') required String publicKey,
  }) = _WalletRegistrationRequest;

  factory WalletRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletRegistrationRequestFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/features/auth/api/dto/owner_info.dart';
import 'package:kkuk_kkuk/features/auth/api/dto/token_info.dart';
import 'package:kkuk_kkuk/features/wallet/api/dto/wallet_info.dart';

part 'authenticate_response.freezed.dart';
part 'authenticate_response.g.dart';

@freezed
abstract class AuthenticateResponse with _$AuthenticateResponse {
  const factory AuthenticateResponse({
    required String status,
    required String message,
    required AuthenticateData data,
  }) = _AuthenticateResponse;

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateResponseFromJson(json);
}

@freezed
abstract class AuthenticateData with _$AuthenticateData {
  const factory AuthenticateData({
    required OwnerInfo owner,
    required TokenInfo tokens,
    List<WalletInfo>? wallets,
  }) = _AuthenticateData;

  factory AuthenticateData.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateDataFromJson(json);
}

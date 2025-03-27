import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_withdrawal_response.freezed.dart';
part 'user_withdrawal_response.g.dart';

@freezed
abstract class UserWithdrawalResponse with _$UserWithdrawalResponse {
  const factory UserWithdrawalResponse({
    required String status,
    required String message,
    dynamic data,
  }) = _UserWithdrawalResponse;

  factory UserWithdrawalResponse.fromJson(Map<String, dynamic> json) =>
      _$UserWithdrawalResponseFromJson(json);
}
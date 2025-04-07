import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_response.freezed.dart';
part 'user_update_response.g.dart';

@freezed
abstract class UserUpdateResponse with _$UserUpdateResponse {
  const factory UserUpdateResponse({
    required String status,
    required String message,
    required UserUpdateData data,
  }) = _UserUpdateResponse;

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateResponseFromJson(json);
}

@freezed
abstract class UserUpdateData with _$UserUpdateData {
  const factory UserUpdateData({
    required int id,
    String? did,
    required String name,
    required String email,
    String? birth,
  }) = _UserUpdateData;

  factory UserUpdateData.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateDataFromJson(json);
}

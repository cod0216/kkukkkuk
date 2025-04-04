import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_request.freezed.dart';
part 'user_update_request.g.dart';

@freezed
abstract class UserUpdateRequest with _$UserUpdateRequest {
  const factory UserUpdateRequest({
    String? name,
    String? birth,
  }) = _UserUpdateRequest;

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);
}
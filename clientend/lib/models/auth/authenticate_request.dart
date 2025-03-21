import 'package:freezed_annotation/freezed_annotation.dart';

part 'authenticate_request.freezed.dart';
part 'authenticate_request.g.dart';

@freezed
abstract class AuthenticateRequest with _$AuthenticateRequest {
  const factory AuthenticateRequest({
    required String name,
    required String email,
    required String birthyear,
    required String birthday,
    required String gender,
    @JsonKey(name: 'provider_id') required String providerId,
  }) = _AuthenticateRequest;

  factory AuthenticateRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateRequestFromJson(json);
}

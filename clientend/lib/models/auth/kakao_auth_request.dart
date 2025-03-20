import 'package:freezed_annotation/freezed_annotation.dart';

part 'kakao_auth_request.freezed.dart';
part 'kakao_auth_request.g.dart';

@freezed
abstract class KakaoAuthRequest with _$KakaoAuthRequest {
  const factory KakaoAuthRequest({
    required String name,
    required String email,
    required String birthyear,
    required String birthday,
    required String gender,
    @JsonKey(name: 'provider_id') required String providerId,
  }) = _KakaoAuthRequest;

  factory KakaoAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthRequestFromJson(json);
}

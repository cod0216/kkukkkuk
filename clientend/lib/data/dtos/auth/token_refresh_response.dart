import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_refresh_response.freezed.dart';
part 'token_refresh_response.g.dart';

@freezed
abstract class TokenRefreshResponse with _$TokenRefreshResponse {
  const factory TokenRefreshResponse({
    required String status,
    required String message,
    required TokenRefreshData data,
  }) = _TokenRefreshResponse;

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseFromJson(json);
}

@freezed
abstract class TokenRefreshData with _$TokenRefreshData {
  const factory TokenRefreshData({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _TokenRefreshData;

  factory TokenRefreshData.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshDataFromJson(json);
}

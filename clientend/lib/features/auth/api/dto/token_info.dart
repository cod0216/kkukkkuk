import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info.freezed.dart';
part 'token_info.g.dart';

@freezed
abstract class TokenInfo with _$TokenInfo {
  const factory TokenInfo({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);
}

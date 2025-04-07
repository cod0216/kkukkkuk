import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';

part 'breeds_response.freezed.dart';
part 'breeds_response.g.dart';

/// 동물 종 목록 조회 응답 DTO
/// Species도 같이 사용함
@freezed
abstract class BreedsResponse with _$BreedsResponse {
  const factory BreedsResponse({
    required String status,
    required String message,
    required List<Breed> data,
  }) = _BreedsResponse;

  factory BreedsResponse.fromJson(Map<String, dynamic> json) =>
      _$BreedsResponseFromJson(json);
}

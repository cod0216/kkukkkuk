import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_delete_response.freezed.dart';
part 'pet_delete_response.g.dart';

/// 반려동물 삭제 응답 DTO
@freezed
abstract class PetDeleteResponse with _$PetDeleteResponse {
  const factory PetDeleteResponse({
    required String status,
    required String message,
    dynamic data,
  }) = _PetDeleteResponse;

  factory PetDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$PetDeleteResponseFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_registration_response.freezed.dart';
part 'pet_registration_response.g.dart';

/// 반려동물 등록 응답 DTO
@freezed
abstract class PetRegistrationResponse with _$PetRegistrationResponse {
  const factory PetRegistrationResponse({
    required String status,
    required String message,
    PetData? data,
  }) = _PetRegistrationResponse;

  factory PetRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$PetRegistrationResponseFromJson(json);
}

/// 반려동물 데이터 DTO
@freezed
abstract class PetData with _$PetData {
  const factory PetData({
    required int id,
    required String did,
    required String name,
    required String gender,
    @JsonKey(name: 'breed_id') required int breedId,
    String? birth,
    @JsonKey(name: 'flag_neutering') required bool flagNeutering,
  }) = _PetData;

  factory PetData.fromJson(Map<String, dynamic> json) =>
      _$PetDataFromJson(json);
}
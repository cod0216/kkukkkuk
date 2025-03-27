import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_registration_request.freezed.dart';
part 'pet_registration_request.g.dart';

/// 반려동물 등록 요청 DTO
@freezed
abstract class PetRegistrationRequest with _$PetRegistrationRequest {
  const factory PetRegistrationRequest({
    required String did,
    required String name,
    required String gender,
    @JsonKey(name: 'breed_id') required int breedId,
    String? birth,
    @JsonKey(name: 'flag_neutering') required bool flagNeutering,
  }) = _PetRegistrationRequest;

  factory PetRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$PetRegistrationRequestFromJson(json);
}
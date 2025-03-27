import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_list_response.freezed.dart';
part 'pet_list_response.g.dart';

/// 반려동물 목록 조회 응답 DTO
@freezed
abstract class PetListResponse with _$PetListResponse {
  const factory PetListResponse({
    required String status,
    required String message,
    required List<PetListData> data,
  }) = _PetListResponse;

  factory PetListResponse.fromJson(Map<String, dynamic> json) =>
      _$PetListResponseFromJson(json);
}

/// 반려동물 목록 데이터 DTO
@freezed
abstract class PetListData with _$PetListData {
  const factory PetListData({
    required int id,
    required String did,
    required String name,
    required String gender,
    @JsonKey(name: 'flag_neutering') required bool flagNeutering,
    @JsonKey(name: 'breed_id') required int breedId,
    @JsonKey(name: 'breed_name') required String breedName,
    String? birth,
    String? age,
    String? image,
  }) = _PetListData;

  factory PetListData.fromJson(Map<String, dynamic> json) =>
      _$PetListDataFromJson(json);
}
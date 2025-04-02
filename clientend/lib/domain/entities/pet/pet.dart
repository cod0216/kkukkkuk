import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';

@freezed
abstract class Pet with _$Pet {
  const factory Pet({
    String? did, // DID
    required String name, // 이름
    required String gender, // 성별
    required String species, // 종
    required String breedName, // 품종
    DateTime? birth, // 생일 'yyyy-MM-dd'
    int? age, // 나이 (생일 date 에서 계산)
    required bool flagNeutering, // 중성화 여부
    String? imageUrl, // 이미지 URL
  }) = _Pet;
}

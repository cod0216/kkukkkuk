import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';

@freezed
abstract class Pet with _$Pet {
  const Pet._(); // 추가: 공통 메서드를 위한 private 생성자

  const factory Pet({
    String? did, // DID
    required String name, // 이름
    required String gender, // 성별
    required String species, // 종
    required String breedName, // 품종
    DateTime? birth, // 생일 'yyyy-MM-dd'
    required bool flagNeutering, // 중성화 여부
    String? imageUrl, // 이미지 URL
  }) = _Pet;

  // 나이를 문자열로 반환하는 getter
  String get ageString {
    if (birth == null) return '';

    final now = DateTime.now();
    final years = now.year - birth!.year;
    if (years > 0) {
      return '$years세';
    } else {
      final months = now.month - birth!.month + (now.year - birth!.year) * 12;
      return '$months개월';
    }
  }
}

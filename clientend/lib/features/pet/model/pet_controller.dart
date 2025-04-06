import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_provider.dart';

/// 반려동물 관련 작업을 처리하는 컨트롤러
class PetController {
  final Ref ref;

  // TODO: 에러 처리 개선
  // TODO: 캐싱 구현
  // TODO: 데이터 유효성 검사 추가
  // TODO: 로깅 구현
  // TODO: 권한 체크 구현

  PetController(this.ref);

  /// 반려동물 목록 조회
  Future<void> getPetList() async {
    await ref.read(petProvider.notifier).getPetList();
  }

  /// 반려동물 등록
  Future<void> registerPet() async {
    await ref.read(petProvider.notifier).registerPet();
  }

  /// 현재 반려동물 정보 설정
  void setCurrentPet({
    required String name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    bool? flagNeutering,
  }) {
    ref
        .read(petProvider.notifier)
        .setCurrentPet(
          name: name,
          species: species,
          breed: breed,
          age: age,
          gender: gender,
          flagNeutering: flagNeutering,
        );
  }
}

/// 반려동물 컨트롤러 프로바이더
final petControllerProvider = Provider<PetController>((ref) {
  return PetController(ref);
});

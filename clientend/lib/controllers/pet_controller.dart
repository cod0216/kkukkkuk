import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/main/pet_provider.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';

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

  /// 반려동물 정보 수정
  Future<void> updatePet(Pet pet) async {
    await ref.read(petProvider.notifier).updatePet(pet);
  }

  /// 반려동물 삭제
  Future<void> deletePet(int petId) async {
    await ref.read(petProvider.notifier).deletePet(petId);
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

  /// 현재 반려동물 정보 초기화
  void resetCurrentPet() {
    ref.read(petProvider.notifier).resetCurrentPet();
  }

  /// 동물 종류 목록 조회
  Future<List<String>> getSpecies() {
    return ref.read(petProvider.notifier).getSpecies();
  }

  /// 품종 목록 조회
  Future<List<String>> getBreeds(String species) {
    return ref.read(petProvider.notifier).getBreeds(species);
  }

  /// 반려동물 상태 조회
  PetState getPetState() {
    return ref.read(petProvider);
  }

  /// 반려동물 존재 여부 확인
  bool hasPets() {
    return ref.read(petProvider).pets.isNotEmpty;
  }

  /// 에러 메시지 조회
  String? getErrorMessage() {
    return ref.read(petProvider).error;
  }

  /// 로딩 상태 조회
  bool isLoading() {
    return ref.read(petProvider).isLoading;
  }
}

/// 반려동물 컨트롤러 프로바이더
final petControllerProvider = Provider<PetController>((ref) {
  return PetController(ref);
});

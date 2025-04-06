import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/providers/pet/pet_register_provider.dart';

/// 반려동물 등록 프로세스를 관리하는 컨트롤러
class PetRegisterController {
  final Ref ref;

  // TODO: 이미지 업로드 처리 구현
  // TODO: 입력값 유효성 검사 강화
  // TODO: 에러 처리 개선
  // TODO: 등록 진행률 표시 기능

  PetRegisterController(this.ref);

  /// 반려동물 기본 정보 설정
  void setBasicInfo({
    required String name,
    String? species,
    String? breed,
    DateTime? birth,
    String? gender,
    bool? flagNeutering,
  }) {
    ref
        .read(petRegisterProvider.notifier)
        .setBasicInfo(
          name: name,
          species: species,
          breed: breed,
          birth: birth,
          gender: gender,
          flagNeutering: flagNeutering,
        );
  }

  /// 다음 등록 단계로 이동
  void moveToNextStep() {
    ref.read(petRegisterProvider.notifier).moveToNextStep();
  }

  /// 이전 등록 단계로 이동
  void moveToPreviousStep() {
    ref.read(petRegisterProvider.notifier).moveToPreviousStep();
  }

  /// 동물 종류 목록 조회
  Future<List<Breed>> getSpecies() {
    return ref.read(petRegisterProvider.notifier).getSpecies();
  }

  /// 품종 목록 조회
  Future<List<Breed>> getBreeds(int species) {
    return ref.read(petRegisterProvider.notifier).getBreeds(species);
  }

  /// 반려동물 등록 처리
  Future<void> registerPet() async {
    await ref.read(petRegisterProvider.notifier).registerPet();
  }

  /// 등록 상태 초기화
  void reset() {
    ref.read(petRegisterProvider.notifier).reset();
  }

  /// 현재 등록 상태 조회
  PetRegisterState getState() {
    return ref.read(petRegisterProvider);
  }

  /// 현재 등록 단계 조회
  PetRegisterStep getCurrentStep() {
    return ref.read(petRegisterProvider).currentStep;
  }

  /// 로딩 상태 조회
  bool isLoading() {
    return ref.read(petRegisterProvider).isLoading;
  }

  /// 에러 메시지 조회
  String? getError() {
    return ref.read(petRegisterProvider).error;
  }
}

/// 반려동물 등록 컨트롤러 프로바이더
final petRegisterControllerProvider = Provider<PetRegisterController>((ref) {
  return PetRegisterController(ref);
});

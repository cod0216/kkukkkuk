import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/services/pet_service.dart';

/// 반려동물 등록 단계
enum PetRegisterStep {
  info, // 기본 정보 입력
  image, // 이미지 업로드
  completed, // 등록 완료
}

/// 반려동물 등록 상태 관리 클래스
class PetRegisterState {
  final PetRegisterStep currentStep; // 현재 등록 단계
  final Pet? pet; // 등록할 반려동물 정보
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지

  // TODO: 이미지 업로드 상태 추가
  // TODO: 등록 진행률 상태 추가
  // TODO: 입력값 유효성 검사 상태 추가
  // TODO: 임시 저장 기능 추가
  // TODO: 등록 히스토리 관리 추가

  PetRegisterState({
    this.currentStep = PetRegisterStep.info,
    this.pet,
    this.isLoading = false,
    this.error,
  });

  /// 상태 복사 메서드
  PetRegisterState copyWith({
    PetRegisterStep? currentStep,
    Pet? pet,
    bool? isLoading,
    String? error,
  }) {
    return PetRegisterState(
      currentStep: currentStep ?? this.currentStep,
      pet: pet ?? this.pet,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 반려동물 등록 상태 관리 노티파이어
class PetRegisterNotifier extends StateNotifier<PetRegisterState> {
  final PetService _petService;

  PetRegisterNotifier(this._petService) : super(PetRegisterState());

  /// 반려동물 기본 정보 설정
  void setBasicInfo({
    required String name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    bool? flagNeutering,
  }) {
    final pet = Pet(
      name: name,
      gender: gender ?? 'MALE',
      breedId: '',
      breedName: breed ?? '',
      age: age != null ? '$age세' : '',
      species: species ?? '',
      flagNeutering: flagNeutering ?? false,
    );

    state = state.copyWith(pet: pet);
  }

  /// 다음 등록 단계로 이동
  void moveToNextStep() {
    switch (state.currentStep) {
      case PetRegisterStep.info:
        state = state.copyWith(currentStep: PetRegisterStep.image);
        break;
      case PetRegisterStep.image:
        state = state.copyWith(currentStep: PetRegisterStep.completed);
        break;
      case PetRegisterStep.completed:
        // 이미 마지막 단계
        break;
    }
  }

  /// 이전 등록 단계로 이동
  void moveToPreviousStep() {
    switch (state.currentStep) {
      case PetRegisterStep.info:
        // 이미 첫 단계
        break;
      case PetRegisterStep.image:
        state = state.copyWith(currentStep: PetRegisterStep.info);
        break;
      case PetRegisterStep.completed:
        state = state.copyWith(currentStep: PetRegisterStep.image);
        break;
    }
  }

  /// 동물 종류 목록 조회
  Future<List<String>> getSpecies() {
    return _petService.getBreeds(null);
  }

  /// 품종 목록 조회
  Future<List<String>> getBreeds(String species) {
    return _petService.getBreeds(species);
  }

  /// 반려동물 등록
  Future<void> registerPet() async {
    if (state.pet == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _petService.registerPet(state.pet!);
      state = state.copyWith(
        isLoading: false,
        currentStep: PetRegisterStep.completed,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 등록에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 등록 상태 초기화
  void reset() {
    state = PetRegisterState();
  }
}

/// 반려동물 등록 프로바이더
final petRegisterProvider =
    StateNotifierProvider<PetRegisterNotifier, PetRegisterState>((ref) {
      final petService = ref.watch(petServiceProvider);
      return PetRegisterNotifier(petService);
    });

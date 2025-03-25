import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/services/pet_service.dart';

/// 반려동물 상태 관리 클래스
class PetState {
  final List<Pet> pets; // 반려동물 목록
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지
  final Pet? currentPet; // 현재 선택된 반려동물

  // TODO: 정렬 기능 추가
  // TODO: 필터링 기능 추가
  // TODO: 검색 기능 추가
  // TODO: 페이지네이션 구현
  // TODO: 즐겨찾기 기능 추가

  PetState({
    this.pets = const [],
    this.isLoading = false,
    this.error,
    this.currentPet,
  });

  /// 상태 복사 메서드
  PetState copyWith({
    List<Pet>? pets,
    bool? isLoading,
    String? error,
    Pet? currentPet,
  }) {
    return PetState(
      pets: pets ?? this.pets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPet: currentPet ?? this.currentPet,
    );
  }
}

/// 반려동물 상태 관리 노티파이어
class PetNotifier extends StateNotifier<PetState> {
  final PetService _petService;

  PetNotifier(this._petService) : super(PetState());

  /// 동물 종류 목록 조회
  Future<List<String>> getSpecies() {
    return _petService.getBreeds(null);
  }

  /// 품종 목록 조회
  Future<List<String>> getBreeds(String species) {
    return _petService.getBreeds(species);
  }

  /// 반려동물 목록 조회
  Future<void> getPetList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pets = await _petService.getPetList();
      state = state.copyWith(pets: pets, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 정보를 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
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
    final currentPet = Pet(
      name: name,
      gender: gender ?? 'MALE',
      breedId: '',
      breedName: breed ?? '',
      age: age != null ? '$age세' : '',
      species: species ?? '',
      flagNeutering: flagNeutering ?? false,
    );

    state = state.copyWith(currentPet: currentPet);
  }

  /// 현재 반려동물 정보 초기화
  void resetCurrentPet() {
    state = state.copyWith(currentPet: null);
  }

  /// 반려동물 등록
  Future<void> registerPet() async {
    if (state.currentPet == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _petService.registerPet(state.currentPet!);
      final updatedPets = await _petService.getPetList();

      state = state.copyWith(
        pets: updatedPets,
        isLoading: false,
        currentPet: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 등록에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 반려동물 정보 수정
  Future<void> updatePet(Pet pet) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _petService.updatePet(pet);
      final updatedPets = await _petService.getPetList();

      state = state.copyWith(pets: updatedPets, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 정보 업데이트에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 반려동물 삭제
  Future<void> deletePet(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _petService.deletePet(petId);
      if (success) {
        final updatedPets = await _petService.getPetList();
        state = state.copyWith(pets: updatedPets, isLoading: false);
      } else {
        throw Exception('Failed to delete pet');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 삭제에 실패했습니다: ${e.toString()}',
      );
    }
  }
}

/// 반려동물 프로바이더
final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
  final petService = ref.watch(petServiceProvider);
  return PetNotifier(petService);
});

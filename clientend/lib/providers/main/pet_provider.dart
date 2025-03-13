import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/services/pet_service.dart';

class PetState {
  final List<Pet> pets;
  final bool isLoading;
  final String? error;
  final Pet? currentPet;

  PetState({
    this.pets = const [],
    this.isLoading = false,
    this.error,
    this.currentPet,
  });

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

class PetNotifier extends StateNotifier<PetState> {
  final PetService _petService;

  PetNotifier(this._petService) : super(PetState());

  Future<List<String>> getSpecies() {
    return _petService.getBreeds(null);
  }

  Future<List<String>> getBreeds(String species) {
    return _petService.getBreeds(species);
  }

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

  void resetCurrentPet() {
    state = state.copyWith(currentPet: null);
  }

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

final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
  return PetNotifier(PetService());
});

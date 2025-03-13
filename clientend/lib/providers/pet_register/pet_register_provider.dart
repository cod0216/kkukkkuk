import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/services/pet_service.dart';

enum PetRegisterStep {
  info, // Basic pet information
  image, // Pet image upload
  completed, // Registration completed
}

class PetRegisterState {
  final PetRegisterStep currentStep;
  final Pet? pet;
  final bool isLoading;
  final String? error;

  PetRegisterState({
    this.currentStep = PetRegisterStep.info,
    this.pet,
    this.isLoading = false,
    this.error,
  });

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

class PetRegisterNotifier extends StateNotifier<PetRegisterState> {
  final PetService _petService;

  PetRegisterNotifier(this._petService) : super(PetRegisterState());

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

  void moveToNextStep() {
    switch (state.currentStep) {
      case PetRegisterStep.info:
        state = state.copyWith(currentStep: PetRegisterStep.image);
        break;
      case PetRegisterStep.image:
        state = state.copyWith(currentStep: PetRegisterStep.completed);
        break;
      case PetRegisterStep.completed:
        // Already at the final step
        break;
    }
  }

  void moveToPreviousStep() {
    switch (state.currentStep) {
      case PetRegisterStep.info:
        // Already at the first step
        break;
      case PetRegisterStep.image:
        state = state.copyWith(currentStep: PetRegisterStep.info);
        break;
      case PetRegisterStep.completed:
        state = state.copyWith(currentStep: PetRegisterStep.image);
        break;
    }
  }

  Future<List<String>> getSpecies() {
    return _petService.getBreeds(null);
  }

  Future<List<String>> getBreeds(String species) {
    return _petService.getBreeds(species);
  }

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

  void reset() {
    state = PetRegisterState();
  }
}

final petRegisterProvider =
    StateNotifierProvider<PetRegisterNotifier, PetRegisterState>((ref) {
      final petService = ref.watch(petServiceProvider);
      return PetRegisterNotifier(petService);
    });

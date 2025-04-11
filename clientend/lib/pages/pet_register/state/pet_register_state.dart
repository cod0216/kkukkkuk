import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/pet_register/state/pet_register_step.dart';

/// 반려동물 등록 상태 관리 클래스
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

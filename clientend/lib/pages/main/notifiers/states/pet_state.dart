import 'package:kkuk_kkuk/entities/pet/pet.dart';

/// 반려동물 상태 관리 클래스
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

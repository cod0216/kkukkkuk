import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/pet_register/pet_register_provider.dart';

class PetRegisterController {
  final Ref ref;

  PetRegisterController(this.ref);

  void setBasicInfo({
    required String name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    bool? flagNeutering,
  }) {
    ref
        .read(petRegisterProvider.notifier)
        .setBasicInfo(
          name: name,
          species: species,
          breed: breed,
          age: age,
          gender: gender,
          flagNeutering: flagNeutering,
        );
  }

  void moveToNextStep() {
    ref.read(petRegisterProvider.notifier).moveToNextStep();
  }

  void moveToPreviousStep() {
    ref.read(petRegisterProvider.notifier).moveToPreviousStep();
  }

  Future<List<String>> getSpecies() {
    return ref.read(petRegisterProvider.notifier).getSpecies();
  }

  Future<List<String>> getBreeds(String species) {
    return ref.read(petRegisterProvider.notifier).getBreeds(species);
  }

  Future<void> registerPet() async {
    await ref.read(petRegisterProvider.notifier).registerPet();
  }

  void reset() {
    ref.read(petRegisterProvider.notifier).reset();
  }

  PetRegisterState getState() {
    return ref.read(petRegisterProvider);
  }

  PetRegisterStep getCurrentStep() {
    return ref.read(petRegisterProvider).currentStep;
  }

  bool isLoading() {
    return ref.read(petRegisterProvider).isLoading;
  }

  String? getError() {
    return ref.read(petRegisterProvider).error;
  }
}

final petRegisterControllerProvider = Provider<PetRegisterController>((ref) {
  return PetRegisterController(ref);
});

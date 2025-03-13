import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/main/pet_provider.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';

class PetController {
  final Ref ref;

  PetController(this.ref);

  Future<void> getPetList() async {
    await ref.read(petProvider.notifier).getPetList();
  }

  Future<void> registerPet() async {
    await ref.read(petProvider.notifier).registerPet();
  }

  Future<void> updatePet(Pet pet) async {
    await ref.read(petProvider.notifier).updatePet(pet);
  }

  Future<void> deletePet(int petId) async {
    await ref.read(petProvider.notifier).deletePet(petId);
  }

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

  void resetCurrentPet() {
    ref.read(petProvider.notifier).resetCurrentPet();
  }

  Future<List<String>> getSpecies() {
    return ref.read(petProvider.notifier).getSpecies();
  }

  Future<List<String>> getBreeds(String species) {
    return ref.read(petProvider.notifier).getBreeds(species);
  }

  PetState getPetState() {
    return ref.read(petProvider);
  }

  bool hasPets() {
    return ref.read(petProvider).pets.isNotEmpty;
  }

  String? getErrorMessage() {
    return ref.read(petProvider).error;
  }

  bool isLoading() {
    return ref.read(petProvider).isLoading;
  }
}

final petControllerProvider = Provider<PetController>((ref) {
  return PetController(ref);
});

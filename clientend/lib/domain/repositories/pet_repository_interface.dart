import 'package:kkuk_kkuk/domain/entities/pet_model.dart';

abstract class IPetRepository {
  Future<List<Pet>> getPetList();
  Future<Pet> registerPet(Pet pet);
  Future<Pet> updatePet(Pet pet);
  Future<bool> deletePet(int petId);
  Future<List<String>> getBreeds(String? species);
}
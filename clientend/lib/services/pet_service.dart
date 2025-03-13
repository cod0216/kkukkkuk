import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';

class PetService {
  final List<Pet> _tempPetList = [
    Pet(
      id: 1,
      name: '공지지',
      gender: 'MALE',
      flagNeutering: true,
      breedId: '1',
      breedName: '스코티시 폴드',
      age: '6세',
      imageUrl: 'https://example.com/cat1.jpg',
      species: '고양이',
    ),
    Pet(
      id: 2,
      name: '강아지',
      gender: 'FEMALE',
      flagNeutering: false,
      breedId: '2',
      breedName: '골든 리트리버',
      age: '1세',
      imageUrl: 'https://example.com/dog1.jpg',
      species: '강아지',
    ),
  ];

  Future<List<Pet>> getPetList() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return [];
      return _tempPetList;
    } catch (e) {
      throw Exception('Failed to fetch pets: $e');
    }
  }

  Future<Pet> registerPet(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to register pet: $e');
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet;
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  Future<Pet> updatePetImage(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet;
    } catch (e) {
      throw Exception('Failed to update pet image: $e');
    }
  }

  Future<bool> deletePet(int petId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  final Map<String, List<String>> breedsMap = {
    '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
    '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
  };

  final List<String> tempSpecies = ['강아지', '고양이'];

  Future<List<String>> getBreeds(String? species) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return breedsMap[species] ?? tempSpecies;
    } catch (e) {
      throw Exception('Failed to fetch breeds: $e');
    }
  }
}

final petServiceProvider = Provider<PetService>((ref) {
  return PetService();
});

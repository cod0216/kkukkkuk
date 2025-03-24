import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/api/api_client.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class PetRepository implements IPetRepository {
  final ApiClient _apiClient;

  // 임시데이터
  final List<Pet> _tempPetList = [
    Pet(
      id: 1,
      name: '꽁지',
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

  final Map<String, List<String>> _breedsMap = {
    '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
    '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
  };

  final List<String> _tempSpecies = ['강아지', '고양이'];

  PetRepository(this._apiClient);

  @override
  Future<List<Pet>> getPetList() async {
    try {
      // TODO: API 호출 로직 추가
      await Future.delayed(const Duration(seconds: 1));
      return _tempPetList;
    } catch (e) {
      throw Exception('Failed to get pet list: $e');
    }
  }

  @override
  Future<Pet> registerPet(Pet pet) async {
    try {
      // TODO: API 호출 로직 추가
      await Future.delayed(const Duration(seconds: 1));
      return pet.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to register pet: $e');
    }
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    try {
      // TODO: API 호출 로직 추가
      await Future.delayed(const Duration(seconds: 1));
      return pet;
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  @override
  Future<bool> deletePet(int petId) async {
    try {
      // TODO: API 호출 로직 추가
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  @override
  Future<List<String>> getBreeds(String? species) async {
    try {
      // TODO: API 호출 로직 추가
      await Future.delayed(const Duration(milliseconds: 100));
      return _breedsMap[species] ?? _tempSpecies;
    } catch (e) {
      throw Exception('Failed to get breeds: $e');
    }
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PetRepository(apiClient);
});

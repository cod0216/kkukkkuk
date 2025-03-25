import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/data/repositories/pet_repository.dart';

class PetService {
  final PetRepository _repository;

  PetService(this._repository);

  Future<List<Pet>> getPetList() async {
    try {
      return await _repository.getPetList();
    } catch (e) {
      throw Exception('반려동물 목록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<Pet> registerPet(Pet pet) async {
    try {
      return await _repository.registerPet(pet);
    } catch (e) {
      throw Exception('반려동물 등록에 실패했습니다: $e');
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    try {
      return await _repository.updatePet(pet);
    } catch (e) {
      throw Exception('반려동물 정보 수정에 실패했습니다: $e');
    }
  }

  Future<bool> deletePet(int petId) async {
    try {
      return await _repository.deletePet(petId);
    } catch (e) {
      throw Exception('반려동물 삭제에 실패했습니다: $e');
    }
  }

  Future<List<String>> getBreeds(String? species) async {
    try {
      return await _repository.getBreeds(species);
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

final petServiceProvider = Provider<PetService>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return PetService(repository);
});

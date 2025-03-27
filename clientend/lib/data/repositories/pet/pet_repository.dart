import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class PetRepository implements IPetRepository {
  final Map<String, List<String>> _breedsMap = {
    '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
    '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
  };

  final List<String> _tempSpecies = ['강아지', '고양이'];

  @override
  Future<List<Pet>> getPetList(String account) async {
    try {
      // TODO: 서버에서 반려동물 목록 조회 API 호출 로직 추가
      await Future.delayed(const Duration(milliseconds: 100));

      // 임시 반려동물 목록 생성
      final List<Pet> pets = [];
      return pets;
    } catch (e) {
      throw Exception('Failed to get pet list: $e');
    }
  }

  @override
  Future<Pet> registerPet(EthPrivateKey credentials, Pet pet) async {
    try {
      // TODO: 반려동물 등록 로직 추가
      Exception('TODO: 반려동물 등록 로직 추가');
      return pet;
    } catch (e) {
      print('반려동물 등록 오류: $e');
      throw Exception('Failed to register pet: $e');
    }
  }

  @override
  Future<Pet> updatePet(EthPrivateKey credentials, Pet pet) async {
    try {
      // TODO: 반려동물 업데이트 로직 추가
      Exception('TODO: 반려동물 업데이트 로직 추가');
      return pet;
    } catch (e) {
      print('반려동물 업데이트 오류: $e');
      throw Exception('Failed to update pet: $e');
    }
  }

  @override
  Future<bool> deletePet(EthPrivateKey credentials, int petId) async {
    try {
      // TODO: 반려동물 삭제 로직 추가
      Exception('TODO: 반려동물 삭제 로직 추가');

      return true;
    } catch (e) {
      print('반려동물 삭제 오류: $e');
      throw Exception('Failed to delete pet: $e');
    }
  }

  @override
  Future<List<String>> getBreeds(String? species) async {
    try {
      // TODO: 서버에서 동물 조회 API 호출 로직 추가
      await Future.delayed(const Duration(milliseconds: 100));
      return _breedsMap[species] ?? _tempSpecies;
    } catch (e) {
      throw Exception('Failed to get breeds: $e');
    }
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository();
});

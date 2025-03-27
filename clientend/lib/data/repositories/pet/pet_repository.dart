import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_registration_response.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class PetRepository implements IPetRepository {
  final ApiClient _apiClient;

  final Map<String, List<String>> _breedsMap = {
    '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
    '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
  };

  final List<String> _tempSpecies = ['강아지', '고양이'];

  PetRepository(this._apiClient);

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
      // API 요청 데이터 생성
      final request = PetRegistrationRequest(
        did: pet.did ?? '',
        name: pet.name,
        gender: pet.gender,
        breedId: int.tryParse(pet.breedId) ?? 1,
        birth: pet.birth?.toIso8601String(),
        flagNeutering: pet.flagNeutering,
      );

      // API 호출
      final response = await _apiClient.post(
        '/api/wallets/me/pets',
        data: request.toJson(),
      );

      // 응답 파싱
      final petResponse = PetRegistrationResponse.fromJson(response.data);

      if (petResponse.data == null) {
        throw Exception('반려동물 등록 실패: ${petResponse.message}');
      }

      // Pet 엔티티로 변환
      return Pet(
        id: petResponse.data!.id,
        did: petResponse.data!.did,
        name: petResponse.data!.name,
        gender: petResponse.data!.gender,
        breedId: petResponse.data!.breedId.toString(),
        breedName: pet.breedName, // API 응답에 breedName이 없으므로 기존 값 유지
        birth:
            petResponse.data!.birth != null
                ? DateTime.parse(petResponse.data!.birth!)
                : null,
        age: pet.age, // API 응답에 age가 없으므로 기존 값 유지
        flagNeutering: petResponse.data!.flagNeutering,
        imageUrl: pet.imageUrl, // API 응답에 imageUrl이 없으므로 기존 값 유지
        species: pet.species, // API 응답에 species가 없으므로 기존 값 유지
      );
    } catch (e) {
      print('반려동물 등록 오류: $e');
      throw Exception('Failed to register pet: $e');
    }
  }

  @override
  Future<Pet> updatePet(EthPrivateKey credentials, Pet pet) async {
    try {
      // TODO: 반려동물 업데이트 로직 추가
      throw Exception('TODO: 반려동물 업데이트 로직 추가');
    } catch (e) {
      print('반려동물 업데이트 오류: $e');
      throw Exception('Failed to update pet: $e');
    }
  }

  @override
  Future<bool> deletePet(EthPrivateKey credentials, int petId) async {
    try {
      // TODO: 반려동물 삭제 로직 추가
      throw Exception('TODO: 반려동물 삭제 로직 추가');
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
  final apiClient = ref.watch(apiClientProvider);
  return PetRepository(apiClient);
});

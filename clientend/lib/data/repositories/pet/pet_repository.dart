import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/pet/breed/breeds_response.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_delete_response.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_list_response.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/pet/pet_registration_response.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';
import 'package:kkuk_kkuk/domain/entities/pet/breed.dart';
import 'package:web3dart/web3dart.dart';

class PetRepository implements IPetRepository {
  final ApiClient _apiClient;

  final List<String> _breedsMap = [
    '골든 리트리버',
    '말티즈',
    '시바견',
    '비숑',
    '포메라니안',
    '치와와',
  ];

  PetRepository(this._apiClient);

  @override
  Future<List<Pet>> getPetList(String account) async {
    try {
      // API 호출
      final response = await _apiClient.get('/api/wallets/me/pets');

      // 응답 파싱
      final petListResponse = PetListResponse.fromJson(response.data);

      // Pet 엔티티 리스트로 변환
      final List<Pet> pets = [];

      for (var petData in petListResponse.data) {
        pets.add(
          Pet(
            id: petData.id,
            did: petData.did,
            name: petData.name,
            gender: petData.gender,
            flagNeutering: petData.flagNeutering,
            breedId: petData.breedId.toString(),
            breedName: petData.breedName,
            birth:
                petData.birth != null ? DateTime.parse(petData.birth!) : null,
            age: petData.age ?? '알 수 없음',
            imageUrl: petData.image,
            species: _determineSpeciesFromBreed(petData.breedName),
          ),
        );
      }

      return pets;
    } catch (e) {
      print('반려동물 목록 조회 실패: $e');
      throw Exception('Failed to get pet list: $e');
    }
  }

  // 품종명에서 종류(강아지/고양이) 유추하는 헬퍼 메서드
  String _determineSpeciesFromBreed(String breedName) {
    if (breedName.toLowerCase().contains('고양이')) {
      return '고양이';
    } else if (breedName.toLowerCase().contains('강아지') ||
        breedName.toLowerCase().contains('견')) {
      return '강아지';
    }
    return '기타';
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
      // API 호출
      final response = await _apiClient.delete('/api/pets/$petId');

      // 응답 파싱
      final deleteResponse = PetDeleteResponse.fromJson(response.data);

      // 성공 여부 반환
      return deleteResponse.status == 'success';
    } catch (e) {
      print('반려동물 삭제 오류: $e');
      throw Exception('Failed to delete pet: $e');
    }
  }

  @override
  Future<List<String>> getBreeds(int? species) async {
    try {
      // TODO: 서버에서 동물 조회 API 호출 로직 추가
      await Future.delayed(const Duration(milliseconds: 100));
      return _breedsMap;
    } catch (e) {
      throw Exception('Failed to get breeds: $e');
    }
  }

  @override
  Future<List<Breed>> getSpecies() async {
    try {
      // API 호출
      final response = await _apiClient.get('/api/breeds');

      // 응답 파싱
      final speciesResponse = BreedsResponse.fromJson(response.data);

      if (speciesResponse.status != 'SUCCESS') {
        throw Exception('동물 종류 목록 조회 실패: ${speciesResponse.message}');
      }

      // 목록 추출
      final List<Breed> speciesList =
          speciesResponse.data
              .map((species) => Breed(name: species.name, id: species.id))
              .toList();

      return speciesList;
    } catch (e) {
      print('동물 종류 목록 조회 실패: $e');
      rethrow;
    }
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PetRepository(apiClient);
});

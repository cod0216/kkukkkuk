import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';

/// 임시 반려동물 목록 데이터
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

/// 품종 정보 맵
final Map<String, List<String>> breedsMap = {
  '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
  '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
};

/// 동물 종류 목록
final List<String> tempSpecies = ['강아지', '고양이'];

/// 반려동물 관련 서비스
class PetService {
  // TODO: API 연동 구현
  // TODO: 이미지 업로드 기능 구현
  // TODO: 캐싱 구현
  // TODO: 에러 처리 개선
  // TODO: 데이터 유효성 검사 추가

  /// 반려동물 목록 조회
  Future<List<Pet>> getPetList() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return _tempPetList;
    } catch (e) {
      throw Exception('반려동물 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// 반려동물 등록
  Future<Pet> registerPet(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('반려동물 등록에 실패했습니다: $e');
    }
  }

  /// 반려동물 정보 수정
  Future<Pet> updatePet(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet;
    } catch (e) {
      throw Exception('반려동물 정보 수정에 실패했습니다: $e');
    }
  }

  /// 반려동물 이미지 수정
  Future<Pet> updatePetImage(Pet pet) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return pet;
    } catch (e) {
      throw Exception('반려동물 이미지 수정에 실패했습니다: $e');
    }
  }

  /// 반려동물 삭제
  Future<bool> deletePet(int petId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('반려동물 삭제에 실패했습니다: $e');
    }
  }

  /// 품종 목록 조회
  Future<List<String>> getBreeds(String? species) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      return breedsMap[species] ?? tempSpecies;
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

/// 반려동물 서비스 프로바이더
final petServiceProvider = Provider<PetService>((ref) {
  return PetService();
});

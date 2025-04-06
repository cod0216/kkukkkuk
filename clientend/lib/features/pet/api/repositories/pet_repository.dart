import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/client/api_client.dart';
import 'package:kkuk_kkuk/shared/blockchain/contracts/registry_contract.dart';
import 'package:kkuk_kkuk/features/pet/api/dto/breeds_response.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:web3dart/web3dart.dart';

class PetRepository implements IPetRepository {
  final RegistryContract _registryContract;
  final ApiClient _apiClient;

  PetRepository(this._apiClient, this._registryContract);

  @override
  Future<List<Pet>> getPetList(String account) async {
    try {
      // 계정 주소로 활성화된 반려동물 목록 조회
      final petAddresses = await _registryContract.getActivePetsByOwner(
        account,
      );
      print('조회된 반려동물 주소 목록: $petAddresses');

      if (petAddresses.isEmpty) {
        return [];
      }

      // 각 반려동물의 상세 정보 조회
      final List<Pet> pets = [];
      for (final petAddress in petAddresses) {
        try {
          // 반려동물 기본 속성 조회
          final attributes = await _registryContract.getAllAttributes(
            petAddress,
          );

          // 반려동물 삭제 여부 확인
          final isDeleted = await _registryContract.isPetDeleted(petAddress);
          if (isDeleted) {
            print('삭제된 반려동물 건너뛰기: $petAddress');
            continue;
          }

          // 속성에서 필요한 정보 추출
          final name = attributes['name']?['value'] as String? ?? '이름 없음';
          final gender = attributes['gender']?['value'] as String? ?? '';
          final speices = attributes['speciesName']?['value'] as String? ?? '';
          final breedName = attributes['breedName']?['value'] as String? ?? '';
          final birthStr = attributes['birth']?['value'] as String? ?? '';
          final flagNeuteringStr =
              attributes['flagNeutering']?['value'] as String? ?? 'false';

          // 출생일 파싱
          DateTime? birth;
          if (birthStr.isNotEmpty) {
            try {
              birth = DateTime.parse(birthStr);
            } catch (e) {
              print('출생일 파싱 오류: $e');
            }
          }

          // 중성화 여부 파싱
          bool flagNeutering = false;
          if (flagNeuteringStr.toLowerCase() == 'true') {
            flagNeutering = true;
          }

          final imageUrl = attributes['profileUrl']?['value'] as String? ?? '';

          // 반려동물 객체 생성
          final pet = Pet(
            did: 'did:pet:$petAddress',
            name: name,
            gender: gender,
            breedName: breedName,
            birth: birth,
            flagNeutering: flagNeutering,
            // 이미지 URL은 별도 저장 필요
            imageUrl: imageUrl,
            // 종류는 품종명에서 유추 가능하나 정확한 정보는 별도 저장 필요
            species: speices,
          );

          pets.add(pet);
        } catch (e) {
          print('반려동물 정보 조회 오류 (건너뛰기): $petAddress - $e');
        }
      }

      return pets;
    } catch (e) {
      print('반려동물 목록 조회 오류: $e');
      throw Exception('Failed to get pet list: $e');
    }
  }

  @override
  Future<Pet> registerPet(EthPrivateKey credentials, Pet pet) async {
    try {
      // 새 반려동물 DID 생성
      final petPrivateKey = EthPrivateKey.createRandom(Random.secure());
      final petAddress = petPrivateKey.address.hex;
      final petDid = 'did:pet:$petAddress';

      print('생성된 반려동물 DID: $petDid');
      print('생성된 반려동물 주소: $petAddress');
      print('반려동물 정보: ${pet.name}, ${pet.gender}, ${pet.breedName}');

      // 계정 정보 확인
      final ownerAddress = credentials.address.hex;
      print('소유자 주소: $ownerAddress');

      try {
        // 반려동물 등록 및 속성 설정
        final txHash = await _registryContract.registerPetWithAttributes(
          credentials: credentials,
          petAddress: petAddress,
          name: pet.name,
          gender: pet.gender,
          breedName: pet.breedName,
          birth: pet.birth?.toIso8601String() ?? '',
          flagNeutering: pet.flagNeutering,
          speciesName: pet.species,
          profileUrl: pet.imageUrl ?? '',
        );

        print('반려동물 등록 트랜잭션: $txHash');

        // 결과 객체 생성
        final result = pet.copyWith(did: petDid);

        print('반려동물 DID 생성 완료: ${result.did}');

        // 트랜잭션이 블록체인에 포함될 때까지 대기
        await _registryContract.waitForTransactionCompletion(txHash);

        print('반려동물 등록 트랜잭션 완료 확인됨');
        return result;
      } catch (contractError) {
        print('컨트랙트 함수 호출 오류: $contractError');

        // 컨트랙트 상태 확인
        try {
          final petExists = await _registryContract.petExists(petAddress);
          print('반려동물 존재 여부: $petExists');

          if (petExists) {
            // 이미 등록된 경우 해당 정보 반환
            print('반려동물이 이미 등록되어 있습니다.');

            // 결과 객체 생성
            final result = pet.copyWith(did: petDid);

            return result;
          }
        } catch (e) {
          print('반려동물 존재 여부 확인 오류: $e');
        }

        throw Exception('반려동물 등록 컨트랙트 호출 실패: $contractError');
      }
    } catch (e) {
      print('반려동물 등록 오류: $e');
      throw Exception('Failed to register pet: $e');
    }
  }

  @override
  Future<Pet> updatePet(EthPrivateKey credentials, Pet pet) async {
    try {
      // DID에서 주소 추출
      final petAddress = pet.did?.replaceFirst('did:pet:', '') ?? '';

      // 속성 업데이트
      if (pet.name.isNotEmpty) {
        await setAttribute(
          credentials: credentials,
          petAddress: petAddress,
          key: 'name',
          value: pet.name,
        );
      }

      if (pet.gender.isNotEmpty) {
        await setAttribute(
          credentials: credentials,
          petAddress: petAddress,
          key: 'gender',
          value: pet.gender,
        );
      }

      if (pet.breedName.isNotEmpty) {
        await setAttribute(
          credentials: credentials,
          petAddress: petAddress,
          key: 'breedName',
          value: pet.breedName,
        );
      }

      if (pet.birth != null) {
        await setAttribute(
          credentials: credentials,
          petAddress: petAddress,
          key: 'birth',
          value: pet.birth!.toIso8601String(),
        );
      }

      await setAttribute(
        credentials: credentials,
        petAddress: petAddress,
        key: 'flagNeutering',
        value: pet.flagNeutering.toString(),
      );

      return pet;
    } catch (e) {
      print('반려동물 업데이트 오류: $e');
      throw Exception('Failed to update pet: $e');
    }
  }

  @override
  Future<bool> deletePet(EthPrivateKey credentials, String petAddress) async {
    try {
      final txHash = await _registryContract.softDeletePet(
        credentials: credentials,
        petAddress: petAddress,
      );

      print('반려동물 삭제 트랜잭션: $txHash');
      return true;
    } catch (e) {
      print('반려동물 삭제 오류: $e');
      throw Exception('Failed to delete pet: $e');
    }
  }

  @override
  Future<List<Breed>> getBreeds(int species) async {
    try {
      // API 호출
      final response = await _apiClient.get('/api/breeds/$species');

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

  @override
  Future<String> setAttribute({
    required Credentials credentials,
    required String petAddress,
    required String key,
    required String value,
  }) async {
    try {
      return await _registryContract.setAttribute(
        validity: 100 * 365 * 24 * 60 * 60, // 100 years
        credentials: credentials,
        petAddress: petAddress,
        name: key,
        value: value,
      );
    } catch (e) {
      print('반려동물 속성 설정 오류: $e');
      throw Exception('반려동물 속성 설정에 실패했습니다: $e');
    }
  }

  @override
  Future<String> addHospitalWithSharing({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod,
  }) async {
    try {
      return await _registryContract.addHospitalWithSharing(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
        scope: scope,
        sharingPeriod: sharingPeriod,
      );
    } catch (e) {
      print('병원 추가 및 공유 계약 생성 오류: $e');
      throw Exception('병원 추가 및 공유 계약 생성에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(String petAddress) async {
    try {
      return await _registryContract.getAllAttributes(petAddress);
    } catch (e) {
      print('반려동물 속성 조회 오류: $e');
      throw Exception('반려동물 속성 조회에 실패했습니다: $e');
    }
  }

  // 진료 기록 추가
  @override
  Future<String> addMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String diagnosis,
    required String hospitalName,
    required String doctorName,
    required String notes,
    required String examinationsJson,
    required String medicationsJson,
    required String vaccinationsJson,
    required String picturesJson,
    required String status,
    required bool flagCertificated,
  }) async {
    try {
      return await _registryContract.addMedicalRecord(
        credentials: credentials,
        petAddress: petAddress,
        diagnosis: diagnosis,
        hospitalName: hospitalName,
        doctorName: doctorName,
        notes: notes,
        examinationsJson: examinationsJson,
        medicationsJson: medicationsJson,
        vaccinationsJson: vaccinationsJson,
        picturesJson: picturesJson,
        status: status,
        flagCertificated: flagCertificated,
      );
    } catch (e) {
      print('진료 기록 추가 오류: $e');
      throw Exception('진료 기록 추가에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> processMedicalRecordImage(
    Map<String, dynamic> ocrData,
  ) async {
    // TODO: 실제 서버 API 엔드포인트 연동
    // TODO: API 요청/응답 모델 정의
    // TODO: API 에러 처리 추가

    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    // Dummy response
    return {
      "diagnosis": "감기",
      "notes": "목이 부었음",
      "doctorName": "김닥터",
      "hospitalName": "일곡동물병원",
      "examinations": [
        {"type": "검사", "key": "혈액검사", "value": "백혈구수치130"},
        {"type": "검사", "key": "xray검사", "value": "골절상"},
      ],
      "medications": [
        {"type": "약물", "key": "타이레놀", "value": "350ml"},
        {"type": "약물", "key": "이부부로펜", "value": "40ml"},
      ],
      "vaccinations": [
        {"type": "접종", "key": "파상풍주사", "value": "1차"},
        {"type": "접종", "key": "예방접종", "value": "2차"},
      ],
      "date": DateTime.now().toIso8601String().split('T')[0],
    };
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final registryContract = ref.watch(petRegistryContractProvider);
  return PetRepository(apiClient, registryContract);
});

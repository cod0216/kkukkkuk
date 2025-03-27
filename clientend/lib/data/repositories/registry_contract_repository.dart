import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/contracts/pet_registry_contract.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RegistryContractRepository implements IRegistryContractRepository {
  final RegistryContract _registryContract;

  RegistryContractRepository(this._registryContract);

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

          // 나이 계산
          String age = '알 수 없음';
          if (birth != null) {
            final now = DateTime.now();
            final years = now.year - birth.year;
            if (years > 0) {
              age = '$years세';
            } else {
              final months =
                  now.month - birth.month + (now.year - birth.year) * 12;
              age = '$months개월';
            }
          }

          // 반려동물 객체 생성
          final pet = Pet(
            did: 'did:pet:$petAddress',
            name: name,
            gender: gender,
            breedName: breedName,
            birth: birth,
            flagNeutering: flagNeutering,
            age: age,
            // 이미지 URL은 별도 저장 필요
            imageUrl: '',
            // 종류는 품종명에서 유추 가능하나 정확한 정보는 별도 저장 필요
            species: '',
            breedId: '',
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
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      return await _registryContract.checkSharingPermission(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      print('공유 권한 확인 오류: $e');
      throw Exception('공유 권한 확인에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAgreementDetails({
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.getAgreementDetails(
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('공유 계약 상세 정보 조회 오류: $e');
      throw Exception('공유 계약 상세 정보 조회에 실패했습니다: $e');
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

  @override
  Future<List<String>> getHospitalPets(String hospitalAddress) async {
    try {
      return await _registryContract.getHospitalPets(hospitalAddress);
    } catch (e) {
      print('병원의 반려동물 목록 조회 오류: $e');
      throw Exception('병원의 반려동물 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<List<String>> getPetHospitals(String petAddress) async {
    try {
      return await _registryContract.getPetHospitals(petAddress);
    } catch (e) {
      print('반려동물의 병원 목록 조회 오류: $e');
      throw Exception('반려동물의 병원 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<bool> petExists(String petAddress) async {
    try {
      return await _registryContract.petExists(petAddress);
    } catch (e) {
      print('반려동물 존재 여부 확인 오류: $e');
      throw Exception('반려동물 존재 여부 확인에 실패했습니다: $e');
    }
  }

  @override
  Future<String> removeHospital({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.removeHospital(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('병원 제거 오류: $e');
      throw Exception('병원 제거에 실패했습니다: $e');
    }
  }

  @override
  Future<String> revokeSharingAgreement({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.revokeSharingAgreement(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('공유 계약 취소 오류: $e');
      throw Exception('공유 계약 취소에 실패했습니다: $e');
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
}

final registryContractRepositoryProvider =
    Provider<IRegistryContractRepository>((ref) {
      final registryContract = ref.watch(petRegistryContractProvider);
      return RegistryContractRepository(registryContract);
    });

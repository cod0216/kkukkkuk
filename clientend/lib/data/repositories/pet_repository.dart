import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/api/contracts/pet_registry_contract.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain_repository.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class PetRepository implements IPetRepository {
  final PetRegistryContract _petRegistryContract;
  final IBlockchainRepository _blockchainRepository;
  late final DeployedContract _contract;

  final Map<String, List<String>> _breedsMap = {
    '강아지': ['골든 리트리버', '말티즈', '시바견', '비숑', '포메라니안', '치와와'],
    '고양이': ['페르시안', '샴', '러시안 블루', '스코티시 폴드', '뱅갈', '아비시니안'],
  };

  final List<String> _tempSpecies = ['강아지', '고양이'];

  PetRepository(this._petRegistryContract, this._blockchainRepository) {
    _initializeContract();
  }

  /// 컨트랙트 초기화
  Future<void> _initializeContract() async {
    try {
      // assets 폴더에서 ABI 파일 로드
      final abiString = await rootBundle.loadString('assets/registryABI.json');
      final abiJson = jsonDecode(abiString);
      final abi = abiJson['registryABI'];

      // 컨트랙트 인스턴스 생성
      _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), 'PetRegistry'),
        EthereumAddress.fromHex(PetRegistryContract.contractAddress),
      );
    } catch (e) {
      debugPrint('컨트랙트 초기화 오류: $e');
    }
  }

  @override
  Future<List<Pet>> getPetList(String account) async {
    try {
      // 블록체인 연결 확인
      final isConnected = await _blockchainRepository.isConnected();
      if (!isConnected) {
        throw Exception('블록체인에 연결되어 있지 않습니다.');
      }
      // TODO: 이벤트 로그 대신 컨트랙트 함수를 사용하여 반려동물 목록 조회
      return [];
    } catch (e) {
      debugPrint('반려동물 목록 조회 오류: $e');
      throw Exception('Failed to get pet list: $e');
    }
  }

  @override
  Future<Pet> registerPet(EthPrivateKey credentials, Pet pet) async {
    try {
      // 블록체인 연결 확인
      final isConnected = await _blockchainRepository.isConnected();
      if (!isConnected) {
        throw Exception('블록체인에 연결되어 있지 않습니다.');
      }

      // 블록체인 클라이언트 가져오기
      final client = _blockchainRepository.getClient();

      // 새 반려동물 DID 생성
      final petPrivateKey = EthPrivateKey.createRandom(Random.secure());
      final petAddress = petPrivateKey.address.hex;
      final petDid = 'did:pet:$petAddress';

      debugPrint('생성된 반려동물 DID: $petDid');
      debugPrint('생성된 반려동물 주소: $petAddress');
      debugPrint('반려동물 정보: ${pet.name}, ${pet.gender}, ${pet.breedName}');

      // 계정 정보 확인
      final ownerAddress = credentials.address.hex;
      debugPrint('소유자 주소: $ownerAddress');

      // 가스 한도 증가 및 가스 가격 설정
      final gasPrice = await client.getGasPrice();
      debugPrint('현재 가스 가격: ${gasPrice.getInWei}');

      try {
        // 반려동물 등록 및 속성 설정
        final txHash = await _petRegistryContract.registerPetWithAttributes(
          credentials: credentials,
          petAddress: petAddress,
          name: pet.name,
          gender: pet.gender,
          breedName: pet.breedName,
          birth: pet.birth?.toIso8601String() ?? '',
          flagNeutering: pet.flagNeutering,
        );

        debugPrint('반려동물 등록 트랜잭션: $txHash');

        // 트랜잭션 완료 대기
        TransactionReceipt? receipt;
        int attempts = 0;
        const maxAttempts = 10;

        while (receipt == null && attempts < maxAttempts) {
          receipt = await client.getTransactionReceipt(txHash);
          if (receipt == null) {
            attempts++;
            debugPrint('트랜잭션 처리 대기 중... 시도: $attempts/$maxAttempts');
            await Future.delayed(const Duration(seconds: 2));
          }
        }

        if (receipt == null) {
          debugPrint('트랜잭션이 아직 처리되지 않았습니다. 나중에 확인하세요.');
        } else {
          final success = receipt.status ?? false;
          debugPrint('트랜잭션 처리 완료: ${success ? '성공' : '실패'}');

          // 트랜잭션 로그 확인
          if (receipt.logs.isNotEmpty) {
            debugPrint('트랜잭션 로그: ${receipt.logs}');
          }

          if (!success) {
            throw Exception('반려동물 등록 트랜잭션이 실패했습니다.');
          }
        }

        // 결과 객체 생성
        final result = pet.copyWith(
          did: petDid,
          // 추가 정보를 저장하고 싶다면 여기에 추가
        );

        debugPrint('반려동물 DID 생성 완료: ${result.did}');

        return result;
      } catch (contractError) {
        debugPrint('컨트랙트 함수 호출 오류: $contractError');

        // 컨트랙트 상태 확인
        try {
          final petExists = await _petRegistryContract.petExists(petAddress);
          debugPrint('반려동물 존재 여부: $petExists');

          if (petExists) {
            // 이미 등록된 경우 해당 정보 반환
            debugPrint('반려동물이 이미 등록되어 있습니다.');

            // 결과 객체 생성
            final result = pet.copyWith(did: petDid);

            return result;
          }
        } catch (e) {
          debugPrint('반려동물 존재 여부 확인 오류: $e');
        }

        throw Exception('반려동물 등록 컨트랙트 호출 실패: $contractError');
      }
    } catch (e) {
      debugPrint('반려동물 등록 오류: $e');
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
      debugPrint('반려동물 업데이트 오류: $e');
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
      debugPrint('반려동물 삭제 오류: $e');
      throw Exception('Failed to delete pet: $e');
    }
  }

  // 반려동물 DID로 삭제하는 메서드 추가
  Future<bool> deletePetByDid(String petDid) async {
    try {
      // TODO: 반려동물 DID로 삭제 로직 추가
      Exception('TODO: 반려동물 DID로 삭제 로직 추가');

      return true;
    } catch (e) {
      debugPrint('반려동물 삭제 오류: $e');
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
  final petRegistryContract = ref.watch(petRegistryContractProvider);
  final blockchainRepository = ref.watch(blockchainRepositoryProvider);
  return PetRepository(petRegistryContract, blockchainRepository);
});

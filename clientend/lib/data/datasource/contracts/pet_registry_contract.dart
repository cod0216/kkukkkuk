import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/connection/blockchain_connection_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/services/blockchain_service.dart';

class PetRegistryContract {
  // SSAFY 블록체인에 배포된 동물 등록 컨트랙트 주소
  static const String contractAddress =
      '0xE3B7abcB7cdd4c483ee891757Bc827592b1B151b';

  final Web3Client _client;
  late final DeployedContract _contract;

  // 레지스트리 컨트랙트 함수들
  late final ContractFunction _registerPetWithAttributes;
  late final ContractFunction _registerPetOwnership;
  late final ContractFunction _changeOwner;
  late final ContractFunction _setAttribute;
  late final ContractFunction _getAttribute;
  late final ContractFunction _getAllAttributes;
  late final ContractFunction _addHospital;
  late final ContractFunction _removeHospital;
  late final ContractFunction _addMedicalRecord;
  late final ContractFunction _appendMedicalRecord;
  late final ContractFunction _softDeleteMedicalRecord;
  late final ContractFunction _softDeletePet;
  late final ContractFunction _petExists;
  late final ContractFunction _isPetDeleted;
  late final ContractFunction _hasAccess;

  PetRegistryContract(this._client);

  /// 컨트랙트 초기화
  Future<void> initialize() async {
    // assets 폴더에서 ABI 파일 로드
    final abiString = await rootBundle.loadString('assets/registryABI.json');
    final abiJson = jsonDecode(abiString);
    final abi = abiJson['registryABI'];

    // 컨트랙트 인스턴스 생성
    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abi), 'PetRegistry'),
      EthereumAddress.fromHex(contractAddress),
    );

    // 컨트랙트 함수 초기화
    _registerPetWithAttributes = _contract.function(
      'registerPetWithAttributes',
    );
    _registerPetOwnership = _contract.function('registerPetOwnership');
    _changeOwner = _contract.function('changeOwner');
    _setAttribute = _contract.function('setAttribute');
    _getAttribute = _contract.function('getAttribute');
    _getAllAttributes = _contract.function('getAllAttributes');
    _addHospital = _contract.function('addHospital');
    _removeHospital = _contract.function('removeHospital');
    _addMedicalRecord = _contract.function('addMedicalRecord');
    _appendMedicalRecord = _contract.function('appendMedicalRecord');
    _softDeleteMedicalRecord = _contract.function('softDeleteMedicalRecord');
    _softDeletePet = _contract.function('softDeletePet');
    _petExists = _contract.function('petExists');
    _isPetDeleted = _contract.function('isPetDeleted');
    _hasAccess = _contract.function('hasAccess');
  }

  /// 반려동물 등록 (속성 포함)
  Future<String> registerPetWithAttributes({
    required Credentials credentials,
    required String petAddress,
    required String name,
    required String gender,
    required String breedName,
    required String birth,
    required bool flagNeutering,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _registerPetWithAttributes,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        name,
        gender,
        breedName,
        birth,
        flagNeutering,
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 소유권 등록
  Future<String> registerPetOwnership({
    required Credentials credentials,
    required String petAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _registerPetOwnership,
      parameters: [EthereumAddress.fromHex(petAddress)],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 소유자 변경
  Future<String> changeOwner({
    required Credentials credentials,
    required String petAddress,
    required String newOwnerAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _changeOwner,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(newOwnerAddress),
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 속성 설정
  Future<String> setAttribute({
    required Credentials credentials,
    required String petAddress,
    required String name,
    required String value,
    required int validity, // 유효기간 (초 단위)
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _setAttribute,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        name,
        value,
        BigInt.from(validity),
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 속성 조회
  Future<Map<String, dynamic>> getAttribute({
    required String petAddress,
    required String name,
  }) async {
    final result = await _client.call(
      contract: _contract,
      function: _getAttribute,
      params: [EthereumAddress.fromHex(petAddress), name],
    );

    if (result.isEmpty) {
      throw Exception('속성을 찾을 수 없습니다.');
    }

    return {
      'value': result[0],
      'expireDate': DateTime.fromMillisecondsSinceEpoch(
        (result[1] as BigInt).toInt() * 1000,
      ),
    };
  }

  /// 반려동물의 모든 속성 조회
  Future<Map<String, dynamic>> getAllAttributes(String petAddress) async {
    final result = await _client.call(
      contract: _contract,
      function: _getAllAttributes,
      params: [EthereumAddress.fromHex(petAddress)],
    );

    if (result.isEmpty) {
      throw Exception('속성을 찾을 수 없습니다.');
    }

    final List<String> names = (result[0] as List).cast<String>();
    final List<String> values = (result[1] as List).cast<String>();
    final List<BigInt> expireDates = (result[2] as List).cast<BigInt>();

    final Map<String, dynamic> attributes = {};
    for (int i = 0; i < names.length; i++) {
      attributes[names[i]] = {
        'value': values[i],
        'expireDate': DateTime.fromMillisecondsSinceEpoch(
          expireDates[i].toInt() * 1000,
        ),
      };
    }

    return attributes;
  }

  /// 병원 추가
  Future<String> addHospital({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _addHospital,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(hospitalAddress),
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 병원 제거
  Future<String> removeHospital({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _removeHospital,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(hospitalAddress),
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 의료 기록 추가
  Future<String> addMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String diagnosis,
    required String treatment,
    required String doctorName,
    required String notes,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _addMedicalRecord,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        diagnosis,
        treatment,
        doctorName,
        notes,
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 의료 기록 추가 (이전 기록에 연결)
  Future<String> appendMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String previousRecordKey,
    required String diagnosis,
    required String treatment,
    required String doctorName,
    required String notes,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _appendMedicalRecord,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        previousRecordKey,
        diagnosis,
        treatment,
        doctorName,
        notes,
      ],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 의료 기록 소프트 삭제
  Future<String> softDeleteMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String recordKey,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _softDeleteMedicalRecord,
      parameters: [EthereumAddress.fromHex(petAddress), recordKey],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 소프트 삭제
  Future<String> softDeletePet({
    required Credentials credentials,
    required String petAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _softDeletePet,
      parameters: [EthereumAddress.fromHex(petAddress)],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 존재 여부 확인
  Future<bool> petExists(String petAddress) async {
    final result = await _client.call(
      contract: _contract,
      function: _petExists,
      params: [EthereumAddress.fromHex(petAddress)],
    );

    return result[0] as bool;
  }

  /// 반려동물 삭제 여부 확인
  Future<bool> isPetDeleted(String petAddress) async {
    final result = await _client.call(
      contract: _contract,
      function: _isPetDeleted,
      params: [EthereumAddress.fromHex(petAddress)],
    );

    return result[0] as bool;
  }

  /// 접근 권한 확인
  Future<bool> hasAccess({
    required String petAddress,
    required String userAddress,
  }) async {
    final result = await _client.call(
      contract: _contract,
      function: _hasAccess,
      params: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
      ],
    );

    return result[0] as bool;
  }
}

final petRegistryContractProvider = Provider<PetRegistryContract>((ref) {
  final getWeb3ClientUseCase = ref.watch(getWeb3ClientUseCaseProvider);
  final web3Client = getWeb3ClientUseCase.execute();
  final contract = PetRegistryContract(web3Client);
  contract.initialize();
  return contract;
});

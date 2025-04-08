import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kkuk_kkuk/shared/config/app_config.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/blockchain/client/blockchain_client.dart';

class RegistryContract {
  final BlockchainClient _blockchainClient;
  late final DeployedContract _contract;

  // 컨트랙트 함수들 정의
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
  late final ContractFunction _addHospitalWithSharing;
  late final ContractFunction _revokeSharingAgreement;
  late final ContractFunction _getActivePetsByOwner;
  late final ContractFunction _getAgreementDetails;
  late final ContractFunction _getHospitalPets;
  late final ContractFunction _getOwnedPetsCount;
  late final ContractFunction _getPetHospitals;
  late final ContractFunction _checkSharingPermission;
  late final ContractFunction _getMedicalRecordUpdates;
  late final ContractFunction _getPetOriginalRecords;

  RegistryContract(this._blockchainClient);

  Future<void> initialize() async {
    try {
      final abiString = await rootBundle.loadString('assets/registryABI.json');
      final abi = jsonDecode(abiString);

      _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), 'PetRegistry'),
        EthereumAddress.fromHex(AppConfig.petRegistryContractAddress),
      );

      // 함수 초기화
      _registerPetWithAttributes = _contract.function(
        'registerPetWithAttributes',
      );
      _registerPetOwnership = _contract.function('_registerPetOwnership');
      _changeOwner = _contract.function('changeOwner');
      _setAttribute = _contract.function('setAttribute');
      _getAttribute = _contract.function('getAttribute');
      _getAllAttributes = _contract.function('getAllAttributes');
      _addHospital = _contract.function('_addHospital');
      _removeHospital = _contract.function('_removeHospital');
      _addMedicalRecord = _contract.function('addMedicalRecord');
      _appendMedicalRecord = _contract.function('appendMedicalRecord');
      _softDeleteMedicalRecord = _contract.function('softDeleteMedicalRecord');
      _softDeletePet = _contract.function('softDeletePet');
      _petExists = _contract.function('petExists');
      _isPetDeleted = _contract.function('isPetDeleted');
      _hasAccess = _contract.function('hasAccess');
      _addHospitalWithSharing = _contract.function('addHospitalWithSharing');
      _revokeSharingAgreement = _contract.function('revokeSharingAgreement');
      _getActivePetsByOwner = _contract.function('getActivePetsByOwner');
      _getAgreementDetails = _contract.function('getAgreementDetails');
      _getHospitalPets = _contract.function('getHospitalPets');
      _getOwnedPetsCount = _contract.function('getOwnedPetsCount');
      _getPetHospitals = _contract.function('getPetHospitals');
      _checkSharingPermission = _contract.function('checkSharingPermission');
    } catch (e) {
      print('컨트랙트 초기화 오류: $e');
      rethrow;
    }
  }

  // 컨트랙트 함수 호출 메서드들
  Future<String> registerPetWithAttributes({
    required Credentials credentials,
    required String petAddress,
    required String name,
    required String gender,
    required String breedName,
    required String birth,
    required bool flagNeutering,
    required String speciesName,
    required String profileUrl,
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
        speciesName,
        profileUrl,
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 반려동물 속성 조회
  Future<Map<String, dynamic>> getAttribute({
    required String petAddress,
    required String name,
  }) async {
    final result = await _blockchainClient.client.call(
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
    final result = await _blockchainClient.client.call(
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 병원 추가
  Future<String> addHospitalWithSharing({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod, // 공유 기간 (초 단위)
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _addHospitalWithSharing,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(hospitalAddress),
        scope,
        BigInt.from(sharingPeriod),
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 계약 취소
  Future<String> revokeSharingAgreement({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _revokeSharingAgreement,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(hospitalAddress),
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 의료 기록 추가
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
    required BigInt treatmentDate,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _addMedicalRecord,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        diagnosis,
        hospitalName,
        doctorName,
        notes,
        examinationsJson,
        medicationsJson,
        vaccinationsJson,
        picturesJson,
        status,
        flagCertificated,
        treatmentDate,
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 의료 기록 추가 (이전 기록에 연결)
  Future<String> appendMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String previousRecordKey,
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
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _appendMedicalRecord,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        previousRecordKey,
        diagnosis,
        hospitalName,
        doctorName,
        notes,
        examinationsJson,
        medicationsJson,
        vaccinationsJson,
        picturesJson,
        status,
        flagCertificated,
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
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

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 반려동물 존재 여부 확인
  Future<bool> petExists(String petAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _petExists,
      params: [EthereumAddress.fromHex(petAddress)],
    );

    return result[0] as bool;
  }

  /// 반려동물 삭제 여부 확인
  Future<bool> isPetDeleted(String petAddress) async {
    final result = await _blockchainClient.client.call(
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
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _hasAccess,
      params: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
      ],
    );

    return result[0] as bool;
  }

  /// 공유 권한 확인
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  }) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _checkSharingPermission,
      params: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
      ],
    );

    return result[0] as bool;
  }

  /// 소유자의 활성화된 반려동물 목록 조회
  Future<List<String>> getActivePetsByOwner(String ownerAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getActivePetsByOwner,
      params: [EthereumAddress.fromHex(ownerAddress)],
    );

    if (result.isEmpty) {
      return [];
    }

    return (result[0] as List)
        .map((address) => address.toString())
        .toList()
        .cast<String>();
  }

  /// 공유 계약 상세 정보 조회
  Future<Map<String, dynamic>> getAgreementDetails({
    required String petAddress,
    required String hospitalAddress,
  }) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getAgreementDetails,
      params: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(hospitalAddress),
      ],
    );

    if (result.isEmpty) {
      throw Exception('공유 계약 정보를 찾을 수 없습니다.');
    }

    return {
      'exists': result[0] as bool,
      'scope': result[1] as String,
      'createdAt': DateTime.fromMillisecondsSinceEpoch(
        (result[2] as BigInt).toInt() * 1000,
      ),
      'expireDate': DateTime.fromMillisecondsSinceEpoch(
        (result[3] as BigInt).toInt() * 1000,
      ),
      'notificationSent': result[4] as bool,
    };
  }

  /// 병원의 반려동물 목록 조회
  Future<List<String>> getHospitalPets(String hospitalAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getHospitalPets,
      params: [EthereumAddress.fromHex(hospitalAddress)],
    );

    if (result.isEmpty) {
      return [];
    }

    return (result[0] as List)
        .map((address) => address.toString())
        .toList()
        .cast<String>();
  }

  /// 소유자의 반려동물 수 조회
  Future<int> getOwnedPetsCount(String ownerAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getOwnedPetsCount,
      params: [EthereumAddress.fromHex(ownerAddress)],
    );

    return (result[0] as BigInt).toInt();
  }

  /// 반려동물의 병원 목록 조회
  Future<List<String>> getPetHospitals(String petAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getPetHospitals,
      params: [EthereumAddress.fromHex(petAddress)],
    );

    if (result.isEmpty) {
      return [];
    }

    return (result[0] as List)
        .map((address) => address.toString())
        .toList()
        .cast<String>();
  }

  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    try {
      return await _blockchainClient.client.getTransactionReceipt(
        txHash.startsWith('0x') ? txHash : '0x$txHash',
      );
    } catch (e) {
      print('트랜잭션 영수증 조회 오류: $e');
      return null;
    }
  }

  // TODO: 전역 처리
  Future<void> waitForTransactionCompletion(String txHash) async {
    try {
      TransactionReceipt? receipt;
      while (receipt == null) {
        receipt = await _blockchainClient.client.getTransactionReceipt(txHash);
        if (receipt == null) {
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    } catch (e) {
      print('Error waiting for transaction completion: $e');
      rethrow;
    }
  }

  Future<List<String>> getMedicalRecordWithUpdates(
    String originalRecordKey,
  ) async {
    try {
      final result = await _blockchainClient.client.call(
        contract: _contract,
        function: _getMedicalRecordUpdates,
        params: [originalRecordKey],
      );

      if (result.isEmpty) {
        return [];
      }

      final List<String> recordKeys = (result[0] as List).cast<String>();
      return recordKeys;
    } catch (e) {
      print('의료기록 업데이트 목록 조회 오류: $e');
      throw Exception('Failed to get medical record updates: $e');
    }
  }

  Future<List<String>> getPetOriginalRecords(String petAddress) async {
    try {
      final result = await _blockchainClient.client.call(
        contract: _contract,
        function: _getPetOriginalRecords,
        params: [EthereumAddress.fromHex(petAddress)],
      );

      if (result.isEmpty) {
        return [];
      }

      final List<String> recordKeys = (result[0] as List).cast<String>();
      return recordKeys;
    } catch (e) {
      print('반려동물 원본 의료기록 목록 조회 오류: $e');
      throw Exception('Failed to get pet original records: $e');
    }
  }
}

final petRegistryContractProvider = Provider<RegistryContract>((ref) {
  final blockchainClient = ref.watch(blockchainClientProvider);
  final contract = RegistryContract(blockchainClient);
  contract.initialize();
  return contract;
});

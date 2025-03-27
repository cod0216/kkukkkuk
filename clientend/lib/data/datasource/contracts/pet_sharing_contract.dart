import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/contracts/blockchain_client.dart';

class PetSharingContract {
  static const String contractAddress =
      '0xfe6aCF0A37532c3FE7e1B642c048Acf8983a7eDC';

  final BlockchainClient _blockchainClient;
  late final DeployedContract _contract;

  // 컨트랙트 함수들 정의
  late final ContractFunction _createSharingRequest;
  late final ContractFunction _acceptSharingRequest;
  late final ContractFunction _rejectSharingRequest;
  late final ContractFunction _cancelSharingRequest;
  late final ContractFunction _revokeSharingAccess;
  late final ContractFunction _getSharingRequests;
  late final ContractFunction _getSharedPets;
  late final ContractFunction _getPetSharingStatus;
  late final ContractFunction _checkSharingPermission;
  late final ContractFunction _updateSharingScope;
  late final ContractFunction _extendSharingPeriod;

  PetSharingContract(this._blockchainClient);

  Future<void> initialize() async {
    try {
      final abiString = await rootBundle.loadString('assets/sharingABI.json');
      final abiJson = jsonDecode(abiString);
      final abi = abiJson['sharingABI'];

      _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi), 'PetSharing'),
        EthereumAddress.fromHex(contractAddress),
      );

      // 함수 초기화
      _createSharingRequest = _contract.function('createSharingRequest');
      _acceptSharingRequest = _contract.function('acceptSharingRequest');
      _rejectSharingRequest = _contract.function('rejectSharingRequest');
      _cancelSharingRequest = _contract.function('cancelSharingRequest');
      _revokeSharingAccess = _contract.function('revokeSharingAccess');
      _getSharingRequests = _contract.function('getSharingRequests');
      _getSharedPets = _contract.function('getSharedPets');
      _getPetSharingStatus = _contract.function('getPetSharingStatus');
      _checkSharingPermission = _contract.function('checkSharingPermission');
      _updateSharingScope = _contract.function('updateSharingScope');
      _extendSharingPeriod = _contract.function('extendSharingPeriod');
    } catch (e) {
      print('컨트랙트 초기화 오류: $e');
      rethrow;
    }
  }

  /// 공유 요청 생성
  Future<String> createSharingRequest({
    required Credentials credentials,
    required String petAddress,
    required String recipientAddress,
    required String scope,
    required int sharingPeriod, // 공유 기간 (초 단위)
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _createSharingRequest,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(recipientAddress),
        scope,
        BigInt.from(sharingPeriod),
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 요청 수락
  Future<String> acceptSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _acceptSharingRequest,
      parameters: [requestId],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 요청 거절
  Future<String> rejectSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _rejectSharingRequest,
      parameters: [requestId],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 요청 취소
  Future<String> cancelSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _cancelSharingRequest,
      parameters: [requestId],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 접근 권한 취소
  Future<String> revokeSharingAccess({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _revokeSharingAccess,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 사용자의 공유 요청 목록 조회
  Future<List<Map<String, dynamic>>> getSharingRequests(
    String userAddress,
  ) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getSharingRequests,
      params: [EthereumAddress.fromHex(userAddress)],
    );

    if (result.isEmpty) {
      return [];
    }

    // TODO: 결과 처리 로직 구현
    List<Map<String, dynamic>> requests = [];

    return requests;
  }

  /// 사용자와 공유된 반려동물 목록 조회
  Future<List<String>> getSharedPets(String userAddress) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getSharedPets,
      params: [EthereumAddress.fromHex(userAddress)],
    );

    if (result.isEmpty) {
      return [];
    }

    return (result[0] as List)
        .map((address) => address.toString())
        .toList()
        .cast<String>();
  }

  /// 반려동물 공유 상태 조회
  Future<Map<String, dynamic>> getPetSharingStatus({
    required String petAddress,
    required String userAddress,
  }) async {
    final result = await _blockchainClient.client.call(
      contract: _contract,
      function: _getPetSharingStatus,
      params: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
      ],
    );

    if (result.isEmpty) {
      throw Exception('공유 정보를 찾을 수 없습니다.');
    }

    return {
      'hasAccess': result[0] as bool,
      'scope': result[1] as String,
      'startTime': DateTime.fromMillisecondsSinceEpoch(
        (result[2] as BigInt).toInt() * 1000,
      ),
      'endTime': DateTime.fromMillisecondsSinceEpoch(
        (result[3] as BigInt).toInt() * 1000,
      ),
    };
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

  /// 공유 범위 업데이트
  Future<String> updateSharingScope({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required String newScope,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _updateSharingScope,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
        newScope,
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }

  /// 공유 기간 연장
  Future<String> extendSharingPeriod({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required int additionalPeriod, // 추가 기간 (초 단위)
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _extendSharingPeriod,
      parameters: [
        EthereumAddress.fromHex(petAddress),
        EthereumAddress.fromHex(userAddress),
        BigInt.from(additionalPeriod),
      ],
    );

    return await _blockchainClient.sendTransaction(
      credentials: credentials,
      transaction: transaction,
    );
  }
}

final petSharingContractProvider = Provider<PetSharingContract>((ref) {
  final blockchainClient = ref.watch(blockchainClientProvider);
  final contract = PetSharingContract(blockchainClient);
  contract.initialize();
  return contract;
});

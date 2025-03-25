import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:kkuk_kkuk/data/api/blockchain_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetRegistryContract {
  // SSAFY 블록체인에 배포된 동물 등록 컨트랙트 주소
  static const String contractAddress =
      '0x1234567890123456789012345678901234567890'; // 실제 컨트랙트 주소로 변경 필요

  final Web3Client _client;
  late final DeployedContract _contract;
  late final ContractFunction _registerPet;
  late final ContractFunction _getPet;
  late final ContractFunction _updatePet;
  late final ContractFunction _transferOwnership;

  PetRegistryContract(this._client);

  /// 컨트랙트 초기화
  Future<void> initialize() async {
    // 컨트랙트 ABI 로드 (실제 프로젝트에서는 assets 폴더에 JSON 파일로 저장)
    const String abiJson = '''[
      {
        "inputs": [
          {"name": "petId", "type": "string"},
          {"name": "name", "type": "string"},
          {"name": "species", "type": "string"},
          {"name": "breed", "type": "string"},
          {"name": "birthDate", "type": "uint256"},
          {"name": "did", "type": "string"}
        ],
        "name": "registerPet",
        "outputs": [{"name": "success", "type": "bool"}],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [{"name": "petId", "type": "string"}],
        "name": "getPet",
        "outputs": [
          {"name": "name", "type": "string"},
          {"name": "species", "type": "string"},
          {"name": "breed", "type": "string"},
          {"name": "birthDate", "type": "uint256"},
          {"name": "owner", "type": "address"},
          {"name": "did", "type": "string"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"name": "petId", "type": "string"},
          {"name": "name", "type": "string"},
          {"name": "species", "type": "string"},
          {"name": "breed", "type": "string"}
        ],
        "name": "updatePet",
        "outputs": [{"name": "success", "type": "bool"}],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"name": "petId", "type": "string"},
          {"name": "newOwner", "type": "address"}
        ],
        "name": "transferOwnership",
        "outputs": [{"name": "success", "type": "bool"}],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]''';

    // 컨트랙트 인스턴스 생성
    _contract = DeployedContract(
      ContractAbi.fromJson(abiJson, 'PetRegistry'),
      EthereumAddress.fromHex(contractAddress),
    );

    // 컨트랙트 함수 초기화
    _registerPet = _contract.function('registerPet');
    _getPet = _contract.function('getPet');
    _updatePet = _contract.function('updatePet');
    _transferOwnership = _contract.function('transferOwnership');
  }

  /// 반려동물 등록 트랜잭션 전송
  Future<String> registerPet({
    required Credentials credentials,
    required String petId,
    required String name,
    required String species,
    required String breed,
    required DateTime birthDate,
    required String did,
  }) async {
    final birthDateTimestamp = BigInt.from(
      birthDate.millisecondsSinceEpoch ~/ 1000,
    );

    final transaction = Transaction.callContract(
      contract: _contract,
      function: _registerPet,
      parameters: [petId, name, species, breed, birthDateTimestamp, did],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 정보 조회
  Future<Map<String, dynamic>> getPet(String petId) async {
    final result = await _client.call(
      contract: _contract,
      function: _getPet,
      params: [petId],
    );

    if (result.isEmpty) {
      throw Exception('반려동물 정보를 찾을 수 없습니다.');
    }

    return {
      'name': result[0],
      'species': result[1],
      'breed': result[2],
      'birthDate': DateTime.fromMillisecondsSinceEpoch(
        (result[3] as BigInt).toInt() * 1000,
      ),
      'owner': (result[4] as EthereumAddress).hex,
      'did': result[5],
    };
  }

  /// 반려동물 정보 업데이트
  Future<String> updatePet({
    required Credentials credentials,
    required String petId,
    required String name,
    required String species,
    required String breed,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _updatePet,
      parameters: [petId, name, species, breed],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }

  /// 반려동물 소유권 이전
  Future<String> transferOwnership({
    required Credentials credentials,
    required String petId,
    required String newOwnerAddress,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _transferOwnership,
      parameters: [petId, EthereumAddress.fromHex(newOwnerAddress)],
    );

    return await _client.sendTransaction(
      credentials,
      transaction,
      chainId: BlockchainService.chainId,
    );
  }
}

final petRegistryContractProvider = Provider<PetRegistryContract>((ref) {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final contract = PetRegistryContract(blockchainService.client);
  // 컨트랙트 초기화
  contract.initialize();
  return contract;
});

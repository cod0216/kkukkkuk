import 'package:kkuk_kkuk/domain/repositories/blockchain/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RevokeSharingAccessUseCase {
  final ISharingContractRepository _repository;

  RevokeSharingAccessUseCase(this._repository);

  Future<String> execute({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      return await _repository.revokeSharingAccess(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      throw Exception('공유 접근 권한 취소에 실패했습니다: $e');
    }
  }
}

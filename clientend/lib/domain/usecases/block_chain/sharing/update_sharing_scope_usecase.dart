import 'package:kkuk_kkuk/domain/repositories/blockchain/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class UpdateSharingScopeUseCase {
  final ISharingContractRepository _repository;

  UpdateSharingScopeUseCase(this._repository);

  Future<String> execute({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required String newScope,
  }) async {
    try {
      return await _repository.updateSharingScope(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
        newScope: newScope,
      );
    } catch (e) {
      throw Exception('공유 범위 업데이트에 실패했습니다: $e');
    }
  }
}

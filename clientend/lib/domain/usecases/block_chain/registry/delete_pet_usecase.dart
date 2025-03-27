import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class DeletePetUseCase {
  final IRegistryContractRepository _repository;

  DeletePetUseCase(this._repository);

  Future<bool> execute(EthPrivateKey credentials, String petAddress) async {
    try {
      return await _repository.deletePet(credentials, petAddress);
    } catch (e) {
      throw Exception('반려동물 삭제에 실패했습니다: $e');
    }
  }
}

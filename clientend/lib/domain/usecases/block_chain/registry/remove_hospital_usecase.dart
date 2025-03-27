import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RemoveHospitalUseCase {
  final IRegistryContractRepository _repository;

  RemoveHospitalUseCase(this._repository);

  Future<String> execute({
    required EthPrivateKey credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _repository.removeHospital(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      throw Exception('병원 제거에 실패했습니다: $e');
    }
  }
}
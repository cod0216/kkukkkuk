import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class AddHospitalWithSharingUseCase {
  final IRegistryContractRepository _repository;

  AddHospitalWithSharingUseCase(this._repository);

  Future<String> execute({
    required EthPrivateKey credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod,
  }) async {
    try {
      return await _repository.addHospitalWithSharing(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
        scope: scope,
        sharingPeriod: sharingPeriod,
      );
    } catch (e) {
      throw Exception('병원 추가 및 공유 설정에 실패했습니다: $e');
    }
  }
}

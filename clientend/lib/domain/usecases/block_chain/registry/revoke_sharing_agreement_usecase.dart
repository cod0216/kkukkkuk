import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RevokeSharingAgreementUseCase {
  final IRegistryContractRepository _repository;

  RevokeSharingAgreementUseCase(this._repository);

  Future<String> execute({
    required EthPrivateKey credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _repository.revokeSharingAgreement(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      throw Exception('공유 계약 취소에 실패했습니다: $e');
    }
  }
}

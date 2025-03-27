import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';

class GetAgreementDetailsUseCase {
  final IRegistryContractRepository _repository;

  GetAgreementDetailsUseCase(this._repository);

  Future<Map<String, dynamic>> execute({
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _repository.getAgreementDetails(
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      throw Exception('공유 계약 상세 정보 조회에 실패했습니다: $e');
    }
  }
}
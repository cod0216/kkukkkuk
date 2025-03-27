import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';

class GetHospitalPetsUseCase {
  final IRegistryContractRepository _repository;

  GetHospitalPetsUseCase(this._repository);

  Future<List<String>> execute(String hospitalAddress) async {
    try {
      return await _repository.getHospitalPets(hospitalAddress);
    } catch (e) {
      throw Exception('병원의 반려동물 목록 조회에 실패했습니다: $e');
    }
  }
}

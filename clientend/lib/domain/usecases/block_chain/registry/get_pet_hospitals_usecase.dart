import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';

class GetPetHospitalsUseCase {
  final IRegistryContractRepository _repository;

  GetPetHospitalsUseCase(this._repository);

  Future<List<String>> execute(String petAddress) async {
    try {
      return await _repository.getPetHospitals(petAddress);
    } catch (e) {
      throw Exception('반려동물의 병원 목록 조회에 실패했습니다: $e');
    }
  }
}
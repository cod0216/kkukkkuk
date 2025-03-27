import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';

class GetPetAttributesUseCase {
  final IRegistryContractRepository _repository;

  GetPetAttributesUseCase(this._repository);

  Future<Map<String, dynamic>> execute(String petAddress) async {
    try {
      return await _repository.getAllAttributes(petAddress);
    } catch (e) {
      throw Exception('반려동물 속성 조회에 실패했습니다: $e');
    }
  }
}
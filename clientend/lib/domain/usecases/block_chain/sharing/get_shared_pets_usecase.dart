import 'package:kkuk_kkuk/domain/repositories/sharing_contract_repository_interface.dart';

class GetSharedPetsUseCase {
  final ISharingContractRepository _repository;

  GetSharedPetsUseCase(this._repository);

  Future<List<String>> execute(String userAddress) async {
    try {
      return await _repository.getSharedPets(userAddress);
    } catch (e) {
      throw Exception('공유된 반려동물 목록 조회에 실패했습니다: $e');
    }
  }
}

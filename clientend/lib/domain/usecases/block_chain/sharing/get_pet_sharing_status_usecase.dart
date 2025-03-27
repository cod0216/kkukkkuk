import 'package:kkuk_kkuk/domain/repositories/blockchain/sharing_contract_repository_interface.dart';

class GetPetSharingStatusUseCase {
  final ISharingContractRepository _repository;

  GetPetSharingStatusUseCase(this._repository);

  Future<Map<String, dynamic>> execute({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      return await _repository.getPetSharingStatus(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      throw Exception('반려동물 공유 상태 조회에 실패했습니다: $e');
    }
  }
}

import 'package:kkuk_kkuk/domain/repositories/blockchain/sharing_contract_repository_interface.dart';

class GetSharingRequestsUseCase {
  final ISharingContractRepository _repository;

  GetSharingRequestsUseCase(this._repository);

  Future<List<Map<String, dynamic>>> execute(String userAddress) async {
    try {
      return await _repository.getSharingRequests(userAddress);
    } catch (e) {
      throw Exception('공유 요청 목록 조회에 실패했습니다: $e');
    }
  }
}

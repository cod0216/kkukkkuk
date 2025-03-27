import 'package:kkuk_kkuk/domain/repositories/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class AcceptSharingRequestUseCase {
  final ISharingContractRepository _repository;

  AcceptSharingRequestUseCase(this._repository);

  Future<String> execute({
    required Credentials credentials,
    required String requestId,
  }) async {
    try {
      return await _repository.acceptSharingRequest(
        credentials: credentials,
        requestId: requestId,
      );
    } catch (e) {
      throw Exception('공유 요청 수락에 실패했습니다: $e');
    }
  }
}
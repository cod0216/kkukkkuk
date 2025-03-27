import 'package:kkuk_kkuk/domain/repositories/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class CreateSharingRequestUseCase {
  final ISharingContractRepository _repository;

  CreateSharingRequestUseCase(this._repository);

  Future<String> execute({
    required Credentials credentials,
    required String petAddress,
    required String recipientAddress,
    required String scope,
    required int sharingPeriod,
  }) async {
    try {
      return await _repository.createSharingRequest(
        credentials: credentials,
        petAddress: petAddress,
        recipientAddress: recipientAddress,
        scope: scope,
        sharingPeriod: sharingPeriod,
      );
    } catch (e) {
      throw Exception('공유 요청 생성에 실패했습니다: $e');
    }
  }
}

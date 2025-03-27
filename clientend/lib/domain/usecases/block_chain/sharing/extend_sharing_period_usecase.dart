import 'package:kkuk_kkuk/domain/repositories/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class ExtendSharingPeriodUseCase {
  final ISharingContractRepository _repository;

  ExtendSharingPeriodUseCase(this._repository);

  Future<String> execute({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required int additionalTime,
  }) async {
    try {
      return await _repository.extendSharingPeriod(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
        additionalTime: additionalTime,
      );
    } catch (e) {
      throw Exception('공유 기간 연장에 실패했습니다: $e');
    }
  }
}

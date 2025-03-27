import 'package:kkuk_kkuk/domain/repositories/registry_contract_repository_interface.dart';

class CheckSharingPermissionUseCase {
  final IRegistryContractRepository _repository;

  CheckSharingPermissionUseCase(this._repository);

  Future<bool> execute({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      return await _repository.checkSharingPermission(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      throw Exception('공유 권한 확인에 실패했습니다: $e');
    }
  }
}
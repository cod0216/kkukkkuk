import 'package:kkuk_kkuk/domain/repositories/pet/pet_medical_record_repository_interface.dart';

class GrantAccessPermissionUseCase {
  final IPetMedicalRecordRepository _repository;

  GrantAccessPermissionUseCase(this._repository);

  Future<bool> execute(
    int petId,
    String targetAddress,
    DateTime expiryDate,
  ) async {
    try {
      return await _repository.grantAccessPermission(
        petId,
        targetAddress,
        expiryDate,
      );
    } catch (e) {
      throw Exception('권한 부여에 실패했습니다: $e');
    }
  }
}

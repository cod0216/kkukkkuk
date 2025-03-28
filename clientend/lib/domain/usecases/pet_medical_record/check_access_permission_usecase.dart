import 'package:kkuk_kkuk/domain/repositories/pet/pet_medical_record_repository_interface.dart';

class CheckAccessPermissionUseCase {
  final IPetMedicalRecordRepository _repository;

  CheckAccessPermissionUseCase(this._repository);

  Future<bool> execute(int petId, String userAddress) async {
    try {
      return await _repository.checkAccessPermission(petId, userAddress);
    } catch (e) {
      throw Exception('접근 권한 확인에 실패했습니다: $e');
    }
  }
}

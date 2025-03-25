import 'package:kkuk_kkuk/domain/repositories/pet_medical_record_repository_interface.dart';

class VerifyMedicalRecordUseCase {
  final IPetMedicalRecordRepository _repository;

  VerifyMedicalRecordUseCase(this._repository);

  Future<bool> execute(int petId, String recordHash) async {
    try {
      return await _repository.verifyMedicalRecord(petId, recordHash);
    } catch (e) {
      throw Exception('진료 기록 검증에 실패했습니다: $e');
    }
  }
}
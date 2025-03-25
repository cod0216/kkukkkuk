import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_medical_record_repository_interface.dart';

class AddMedicalRecordUseCase {
  final IPetMedicalRecordRepository _repository;

  AddMedicalRecordUseCase(this._repository);

  Future<bool> execute(int petId, PetMedicalRecord record) async {
    try {
      return await _repository.addMedicalRecord(petId, record);
    } catch (e) {
      throw Exception('진료 기록 추가에 실패했습니다: $e');
    }
  }
}
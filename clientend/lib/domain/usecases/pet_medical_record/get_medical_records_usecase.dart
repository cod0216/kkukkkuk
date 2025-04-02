import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_medical_record_repository_interface.dart';

class GetMedicalRecordsUseCase {
  final IPetMedicalRecordRepository _repository;

  GetMedicalRecordsUseCase(this._repository);

  Future<List<PetMedicalRecord>> execute(int petId) async {
    try {
      return await _repository.getMedicalRecords(petId);
    } catch (e) {
      throw Exception('진료 기록을 가져오는데 실패했습니다: $e');
    }
  }
}

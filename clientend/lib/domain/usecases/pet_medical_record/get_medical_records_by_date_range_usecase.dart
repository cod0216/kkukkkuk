import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_medical_record_repository_interface.dart';

class GetMedicalRecordsByDateRangeUseCase {
  final IPetMedicalRecordRepository _repository;

  GetMedicalRecordsByDateRangeUseCase(this._repository);

  Future<List<PetMedicalRecord>> execute(
    int petId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _repository.getMedicalRecordsByDateRange(
        petId,
        startDate,
        endDate,
      );
    } catch (e) {
      throw Exception('기간별 진료 기록 조회에 실패했습니다: $e');
    }
  }
}
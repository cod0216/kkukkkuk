import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository.dart';

class ProcessMedicalRecordImageUseCase {
  final PetRepository _repository;

  ProcessMedicalRecordImageUseCase(this._repository);

  Future<Map<String, dynamic>> execute(Map<String, dynamic> ocrData) async {
    return await _repository.processMedicalRecordImage(ocrData);
  }
}

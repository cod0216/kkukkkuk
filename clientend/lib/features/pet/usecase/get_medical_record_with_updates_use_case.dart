import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';

class GetMedicalRecordWithUpdatesUseCase {
  final IPetRepository _repository;

  GetMedicalRecordWithUpdatesUseCase(this._repository);

  Future<List<String>> execute(String originalRecordKey) async {
    return await _repository.getMedicalRecordWithUpdates(originalRecordKey);
  }
}
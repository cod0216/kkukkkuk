import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';

class GetPetOriginalRecordsUseCase {
  final IPetRepository _repository;

  GetPetOriginalRecordsUseCase(this._repository);

  Future<List<String>> execute(String petAddress) async {
    return await _repository.getPetOriginalRecords(petAddress);
  }
}
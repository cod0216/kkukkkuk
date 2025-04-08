import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';

class GetSpeciesUseCase {
  final IPetRepository _repository;

  GetSpeciesUseCase(this._repository);

  Future<List<Breed>> execute() async {
    try {
      return await _repository.getSpecies();
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

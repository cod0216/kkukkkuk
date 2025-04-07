import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';

class GetBreedsUseCase {
  final IPetRepository _repository;

  GetBreedsUseCase(this._repository);

  Future<List<Breed>> execute(int speciesId) async {
    try {
      return await _repository.getBreeds(speciesId);
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

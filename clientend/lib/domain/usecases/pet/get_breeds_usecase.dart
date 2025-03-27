import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';

class GetBreedsUseCase {
  final IPetRepository _repository;

  GetBreedsUseCase(this._repository);

  Future<List<String>> execute(String? species) async {
    try {
      return await _repository.getBreeds(species);
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

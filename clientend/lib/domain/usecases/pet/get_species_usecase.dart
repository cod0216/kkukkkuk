import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';

class GetSpeciesUseCase {
  final IPetRepository _repository;

  GetSpeciesUseCase(this._repository);

  Future<List<String>> execute() async {
    try {
      return await _repository.getSpecies();
    } catch (e) {
      throw Exception('품종 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class GetPetListUseCase {
  final IPetRepository _repository;

  GetPetListUseCase(this._repository);

  Future<List<Pet>> execute(String address) async {
    try {
      return await _repository.getPetList(address);
    } catch (e) {
      throw Exception('반려동물 목록을 불러오는데 실패했습니다: $e');
    }
  }
}

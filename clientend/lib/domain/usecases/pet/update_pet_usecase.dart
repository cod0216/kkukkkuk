import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class UpdatePetUseCase {
  final IPetRepository _repository;

  UpdatePetUseCase(this._repository);

  Future<Pet> execute(Pet pet) async {
    try {
      return await _repository.updatePet(pet);
    } catch (e) {
      throw Exception('반려동물 정보 수정에 실패했습니다: $e');
    }
  }
}
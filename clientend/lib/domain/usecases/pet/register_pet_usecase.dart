import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class RegisterPetUseCase {
  final IPetRepository _repository;

  RegisterPetUseCase(this._repository);

  Future<Pet> execute(Pet pet) async {
    try {
      return await _repository.registerPet(pet);
    } catch (e) {
      throw Exception('반려동물 등록에 실패했습니다: $e');
    }
  }
}
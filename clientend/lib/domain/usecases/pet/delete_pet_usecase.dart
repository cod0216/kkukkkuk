import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class DeletePetUseCase {
  final IPetRepository _repository;

  DeletePetUseCase(this._repository);

  Future<bool> execute(int petId) async {
    try {
      return await _repository.deletePet(petId);
    } catch (e) {
      throw Exception('반려동물 삭제에 실패했습니다: $e');
    }
  }
}
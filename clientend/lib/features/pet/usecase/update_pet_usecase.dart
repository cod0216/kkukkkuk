import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class UpdatePetUseCase {
  final IPetRepository _repository;

  UpdatePetUseCase(this._repository);

  Future<Pet> execute(EthPrivateKey credentials, Pet pet) async {
    try {
      return await _repository.updatePet(credentials, pet);
    } catch (e) {
      throw Exception('반려동물 정보 수정에 실패했습니다: $e');
    }
  }
}

import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 등록 UseCase
class RegisterPetUseCase {
  final IPetRepository _repository;

  RegisterPetUseCase(this._repository);

  /// 반려동물 등록 실행
  Future<Pet> execute(EthPrivateKey credentials, Pet pet) async {
    try {
      return await _repository.registerPet(credentials, pet);
    } catch (e) {
      print('반려동물 등록 실패: $e');
      throw Exception('반려동물 등록에 실패했습니다: $e');
    }
  }
}

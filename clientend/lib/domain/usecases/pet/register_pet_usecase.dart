import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RegisterPetUseCase {
  final IRegistryContractRepository _repository;

  RegisterPetUseCase(this._repository);

  Future<Pet> execute(EthPrivateKey credentials, Pet pet) async {
    try {
      return await _repository.registerPet(credentials, pet);
    } catch (e) {
      throw Exception('반려동물 등록에 실패했습니다: $e');
    }
  }
}

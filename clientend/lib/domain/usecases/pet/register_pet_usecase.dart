import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class RegisterPetUseCase {
  final IPetRepository _petRepository;

  RegisterPetUseCase(this._petRepository);

  Future<Pet> execute(Pet pet) async {
    try {
      return await _petRepository.registerPet(pet);
    } catch (e) {
      throw Exception('Failed to register pet: $e');
    }
  }
}
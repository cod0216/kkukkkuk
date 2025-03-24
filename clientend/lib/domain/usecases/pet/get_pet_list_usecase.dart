import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/repositories/pet_repository_interface.dart';

class GetPetListUseCase {
  final IPetRepository _petRepository;

  GetPetListUseCase(this._petRepository);

  Future<List<Pet>> execute() async {
    try {
      return await _petRepository.getPetList();
    } catch (e) {
      throw Exception('Failed to get pet list: $e');
    }
  }
}
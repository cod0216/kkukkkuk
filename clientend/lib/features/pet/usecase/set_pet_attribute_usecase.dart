import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class SetPetAttributeUseCase {
  final IPetRepository _repository;

  SetPetAttributeUseCase(this._repository);

  Future<String> execute({
    required EthPrivateKey credentials,
    required String petAddress,
    required String key,
    required String value,
  }) async {
    try {
      return await _repository.setAttribute(
        credentials: credentials,
        petAddress: petAddress,
        key: key,
        value: value,
      );
    } catch (e) {
      throw Exception('반려동물 속성 설정에 실패했습니다: $e');
    }
  }
}

import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';

/// 반려동물 목록 조회 UseCase
class GetPetListUseCase {
  final IPetRepository _repository;

  GetPetListUseCase(this._repository);

  /// 반려동물 목록 조회 실행
  ///
  /// [account] 사용자 계정 주소
  Future<List<Pet>> execute(String account) async {
    try {
      return await _repository.getPetList(account);
    } catch (e) {
      print('반려동물 목록 조회 실패: $e');
      throw Exception('반려동물 목록 조회에 실패했습니다: $e');
    }
  }
}

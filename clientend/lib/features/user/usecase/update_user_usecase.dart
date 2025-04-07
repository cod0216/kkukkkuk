import 'package:kkuk_kkuk/features/user/api/dto/user_update_response.dart';
import 'package:kkuk_kkuk/features/user/api/repositories/user_repository_interface.dart';

class UpdateUserUseCase {
  final IUserRepository _repository;

  UpdateUserUseCase(this._repository);

  Future<UserUpdateResponse> execute({String? name, String? birth}) async {
    try {
      return await _repository.updateUser(name: name, birth: birth);
    } catch (e) {
      print('사용자 정보 업데이트 실패: $e');
      rethrow;
    }
  }
}

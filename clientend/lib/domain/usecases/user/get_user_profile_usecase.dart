import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/dtos/user/user_profile_response.dart';
import 'package:kkuk_kkuk/data/repositories/user/user_repository.dart';
import 'package:kkuk_kkuk/domain/repositories/user/user_repository_interface.dart';

class GetUserProfileUseCase {
  final IUserRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserProfileResponse> execute() async {
    return await _repository.getUserProfile();
  }
}

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

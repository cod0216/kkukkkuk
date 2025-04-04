import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/dtos/user/user_profile_response.dart';
import 'package:kkuk_kkuk/data/repositories/user/user_repository.dart';
import 'package:kkuk_kkuk/domain/entities/user.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/domain/repositories/user/user_repository_interface.dart';

class GetUserProfileUseCase {
  final IUserRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<User> execute() async {
    final response = await _repository.getUserProfile();
    return _convertToEntity(response);
  }

  User _convertToEntity(UserProfileResponse response) {
    final ownerInfo = response.data.owner;
    final walletInfoList = response.data.wallets;

    return User(
      id: ownerInfo.id,
      did: ownerInfo.did,
      name: ownerInfo.name,
      email: ownerInfo.email,
      birthYear: ownerInfo.birth?.substring(0, 4) ?? '',
      birthDay: ownerInfo.birth?.substring(4) ?? '',
      gender: '',
      providerId: 0,
      wallets:
          walletInfoList
              ?.map(
                (wallet) => Wallet(
                  id: wallet.id,
                  name: wallet.name,
                  address: wallet.address,
                ),
              )
              .toList() ??
          [],
    );
  }
}

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

import 'package:kkuk_kkuk/data/dtos/auth/authenticate_request.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/entities/wallet/wallet.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/auth_repository_interface.dart';

class LoginWithKakaoUseCase {
  final IAuthRepository _authRepository;

  LoginWithKakaoUseCase(this._authRepository);

  Future<User> execute(User user) async {
    try {
      final request = AuthenticateRequest(
        name: user.name,
        email: user.email,
        birthyear: user.birthYear,
        birthday: user.birthDay,
        gender: user.gender,
        providerId: user.providerId.toString(),
      );

      final response = await _authRepository.authenticateWithKakao(request);
      print('Backend authentication successful');

      // Map the response to User entity
      final ownerInfo = response.data.owner;
      final wallets =
          response.data.wallets
              ?.map(
                (walletInfo) => Wallet(
                  id: walletInfo.id,
                  address: walletInfo.address,
                  name: walletInfo.name ?? '',
                ),
              )
              .toList();

      return User(
        id: ownerInfo.id,
        name: ownerInfo.name,
        email: ownerInfo.email,
        birthYear:
            user.birthYear, // Keep original value as it might not be in response
        birthDay: ownerInfo.birth ?? user.birthDay,
        gender:
            user.gender, // Keep original value as it might not be in response
        providerId: user.providerId,
        profileImage: ownerInfo.image,
        wallets: wallets ?? [],
      );
    } catch (e) {
      print('Failed to login with Kakao: $e');
      throw Exception('Failed to login with Kakao: $e');
    }
  }
}

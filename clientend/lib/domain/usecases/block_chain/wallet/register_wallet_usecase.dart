import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/wallet_repository.dart';

class RegisterWalletUseCase {
  final WalletRepository _walletRepository;

  RegisterWalletUseCase(this._walletRepository);

  Future<WalletRegistrationResponse> execute({
    required String did,
    required String address,
    required String encryptedPrivateKey,
    required String publicKey,
  }) async {
    try {
      final request = WalletRegistrationRequest(
        did: did,
        address: address,
        privateKey: encryptedPrivateKey,
        publicKey: publicKey,
      );

      return await _walletRepository.registerWalletAPI(request);
    } catch (e) {
      throw Exception('지갑 등록에 실패했습니다: $e');
    }
  }
}

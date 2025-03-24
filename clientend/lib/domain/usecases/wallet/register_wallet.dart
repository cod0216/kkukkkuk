import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/domain/repositories/wallet_repository_interface.dart';

class RegisterWalletUseCase {
  final IWalletRepository _walletRepository;

  RegisterWalletUseCase(this._walletRepository);

  Future<Wallet> execute({
    required String did,
    required String address,
    required String encryptedPrivateKey,
    required String publicKey,
  }) async {
    try {
      return await _walletRepository.registerWallet(
        did: did,
        address: address,
        encryptedPrivateKey: encryptedPrivateKey,
        publicKey: publicKey,
      );
    } catch (e) {
      throw Exception('Failed to register wallet: $e');
    }
  }
}

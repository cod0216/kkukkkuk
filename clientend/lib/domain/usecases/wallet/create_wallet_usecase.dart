import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/domain/repositories/wallet_repository_interface.dart';

class CreateWalletUseCase {
  final IWalletRepository _walletRepository;

  CreateWalletUseCase(this._walletRepository);

  Future<Wallet> execute(String userId) async {
    try {
      return await _walletRepository.createWallet(userId);
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }
}

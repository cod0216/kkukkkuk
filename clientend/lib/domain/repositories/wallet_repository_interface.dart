import 'package:kkuk_kkuk/domain/entities/wallet.dart';

abstract class IWalletRepository {
  Future<Wallet> createWallet(String userId);
  Future<Wallet> registerWallet({
    required String did,
    required String address,
    required String encryptedPrivateKey,
    required String publicKey,
  });
}

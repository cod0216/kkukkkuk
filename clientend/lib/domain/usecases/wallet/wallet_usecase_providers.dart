import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/wallet_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/decrypt_private_key_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/encrypt_private_key_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/generate_wallet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/register_wallet_usecase.dart';

final generateWalletUseCaseProvider = Provider<GenerateWalletUseCase>((ref) {
  return GenerateWalletUseCase();
});

final encryptPrivateKeyUseCaseProvider = Provider<EncryptPrivateKeyUseCase>((ref) {
  return EncryptPrivateKeyUseCase();
});

final decryptPrivateKeyUseCaseProvider = Provider<DecryptPrivateKeyUseCase>((ref) {
  return DecryptPrivateKeyUseCase();
});

final registerWalletUseCaseProvider = Provider<RegisterWalletUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return RegisterWalletUseCase(walletRepository);
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/wallet_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/wallet/create_wallet_from_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/wallet/register_wallet_usecase.dart';

final registerWalletUseCaseProvider = Provider<RegisterWalletUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return RegisterWalletUseCase(walletRepository);
});

final createWalletFromMnemonicUseCaseProvider =
    Provider<CreateWalletFromMnemonicUseCase>((ref) {
      return CreateWalletFromMnemonicUseCase();
    });

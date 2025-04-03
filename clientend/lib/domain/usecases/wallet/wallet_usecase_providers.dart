import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/wallet_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/create_wallet_from_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/delete_wallet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/get_wallet_detail_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/get_wallet_info_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/register_wallet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/update_wallet_usecase.dart';

final registerWalletUseCaseProvider = Provider<RegisterWalletUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return RegisterWalletUseCase(walletRepository);
});

final getWalletInfoUseCaseProvider = Provider<GetWalletInfoUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return GetWalletInfoUseCase(walletRepository);
});

final getWalletDetailUseCaseProvider = Provider<GetWalletDetailUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return GetWalletDetailUseCase(walletRepository);
});

final updateWalletUseCaseProvider = Provider<UpdateWalletUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return UpdateWalletUseCase(walletRepository);
});

final deleteWalletUseCaseProvider = Provider<DeleteWalletUseCase>((ref) {
  final walletRepository = ref.watch(walletRepositoryProvider);
  return DeleteWalletUseCase(walletRepository);
});

final createWalletFromMnemonicUseCaseProvider =
    Provider<CreateWalletFromMnemonicUseCase>((ref) {
      return CreateWalletFromMnemonicUseCase();
    });

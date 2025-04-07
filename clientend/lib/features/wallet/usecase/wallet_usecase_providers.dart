import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/wallet/api/repositories/wallet_repository.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/create_wallet_from_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/delete_wallet_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/get_wallet_detail_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/get_wallet_info_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/register_wallet_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/update_wallet_usecase.dart';

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

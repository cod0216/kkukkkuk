import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/connection/check_blockchain_connection_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/connection/get_web3_client_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/wallet/get_wallet_balance_usecase.dart';

final checkBlockchainConnectionUseCaseProvider =
    Provider<CheckBlockchainConnectionUseCase>((ref) {
      final repository = ref.watch(blockchainRepositoryProvider);
      return CheckBlockchainConnectionUseCase(repository);
    });

final getWeb3ClientUseCaseProvider = Provider<GetWeb3ClientUseCase>((ref) {
  final repository = ref.watch(blockchainRepositoryProvider);
  return GetWeb3ClientUseCase(repository);
});

final getWalletBalanceUseCaseProvider = Provider<GetWalletBalanceUseCase>((
  ref,
) {
  final repository = ref.watch(blockchainRepositoryProvider);
  return GetWalletBalanceUseCase(repository);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/blockchain/blockchain_client.dart';
import 'package:kkuk_kkuk/shared/blockchain/check_blockchain_connection_usecase.dart';
import 'package:kkuk_kkuk/shared/blockchain/get_web3_client_usecase.dart';

final checkBlockchainConnectionUseCaseProvider =
    Provider<CheckBlockchainConnectionUseCase>((ref) {
      final client = ref.watch(blockchainClientProvider);
      return CheckBlockchainConnectionUseCase(client);
    });

final getWeb3ClientUseCaseProvider = Provider<GetWeb3ClientUseCase>((ref) {
  final client = ref.watch(blockchainClientProvider);
  return GetWeb3ClientUseCase(client);
});

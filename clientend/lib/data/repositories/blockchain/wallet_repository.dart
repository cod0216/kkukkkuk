import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class WalletRepository implements IWalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  @override
  Future<WalletRegistrationResponse> registerWallet(
    WalletRegistrationRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/wallets',
        data: request.toJson(),
      );

      final walletResponse = WalletRegistrationResponse.fromJson(response.data);
      return walletResponse;
    } catch (e) {
      print('지갑 등록 API 호출 실패: $e');
      rethrow;
    }
  }
}

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

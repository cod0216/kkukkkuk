import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';


class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<WalletRegistrationResponse> registerWalletAPI(
    WalletRegistrationRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/owners/me/wallets',
        data: request.toJson(),
      );

      final walletResponse = WalletRegistrationResponse.fromJson(response.data);

      return walletResponse;
    } catch (e) {
      print('registerWalletAPI Error: $e');
      rethrow;
    }
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

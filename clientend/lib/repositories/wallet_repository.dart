import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet/wallet_registration_request.dart';
import '../models/wallet/wallet_registration_response.dart';
import '../services/api_client.dart';

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
      return WalletRegistrationResponse.fromJson(response.data);
    } catch (e) {
      print('registerWallet Error: $e');
      rethrow;
    }
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

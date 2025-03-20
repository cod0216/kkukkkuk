import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet/wallet_registration_request.dart';
import '../models/wallet/wallet_registration_response.dart';
import '../services/api_client.dart';

class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<WalletRegistrationResponse> registerWallet(
    WalletRegistrationRequest request,
  ) async {
    try {
      print(request);
      final response = await _apiClient.post(
        '/api/wallets/me',
        data: request.toJson(),
      );
      return WalletRegistrationResponse.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

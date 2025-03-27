import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_info_response.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_response.dart';
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

  @override
  Future<WalletInfoResponse> getWalletInfo() async {
    try {
      final response = await _apiClient.get('/api/wallets/me');
      return WalletInfoResponse.fromJson(response.data);
    } catch (e) {
      print('지갑 정보 조회 실패: $e');
      rethrow;
    }
  }
  
  @override
  Future<WalletUpdateResponse> updateWallet(
    WalletUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        '/api/wallets/me',
        data: request.toJson(),
      );
      return WalletUpdateResponse.fromJson(response.data);
    } catch (e) {
      print('지갑 정보 업데이트 실패: $e');
      rethrow;
    }
  }
}

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

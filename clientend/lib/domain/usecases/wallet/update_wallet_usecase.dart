import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class UpdateWalletUseCase {
  final IWalletRepository _walletRepository;

  UpdateWalletUseCase(this._walletRepository);

  /// 지갑 정보 업데이트
  Future<WalletUpdateResponse> execute({
    required int walletId,
    required String name,
  }) async {
    try {
      final request = WalletUpdateRequest(name: name);
      return await _walletRepository.updateWallet(walletId, request);
    } catch (e) {
      print('지갑 정보 업데이트 실패: $e');
      throw Exception('지갑 정보 업데이트에 실패했습니다: $e');
    }
  }
}
import 'package:kkuk_kkuk/features/wallet/api/repositories/dto/wallet_delete_response.dart';
import 'package:kkuk_kkuk/features/wallet/api/repositories/wallet_repository_interface.dart';

class DeleteWalletUseCase {
  final IWalletRepository _walletRepository;

  DeleteWalletUseCase(this._walletRepository);

  /// 지갑 정보 삭제
  Future<WalletDeleteResponse> execute(int walletId) async {
    try {
      return await _walletRepository.deleteWallet(walletId);
    } catch (e) {
      print('지갑 정보 삭제 실패: $e');
      throw Exception('지갑 정보 삭제에 실패했습니다: $e');
    }
  }
}

import 'package:kkuk_kkuk/data/dtos/wallet/wallet_delete_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class DeleteWalletUseCase {
  final IWalletRepository _walletRepository;

  DeleteWalletUseCase(this._walletRepository);

  /// 현재 로그인한 사용자의 지갑 정보 삭제
  Future<WalletDeleteResponse> execute() async {
    try {
      return await _walletRepository.deleteWallet();
    } catch (e) {
      print('지갑 정보 삭제 실패: $e');
      throw Exception('지갑 정보 삭제에 실패했습니다: $e');
    }
  }
}
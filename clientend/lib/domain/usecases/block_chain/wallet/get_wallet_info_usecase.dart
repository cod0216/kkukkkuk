import 'package:kkuk_kkuk/data/dtos/wallet/wallet_info_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class GetWalletInfoUseCase {
  final IWalletRepository _walletRepository;

  GetWalletInfoUseCase(this._walletRepository);

  /// 현재 로그인한 사용자의 지갑 정보 조회
  Future<WalletInfoResponse> execute() async {
    try {
      return await _walletRepository.getWalletInfo();
    } catch (e) {
      print('지갑 정보 조회 실패: $e');
      throw Exception('지갑 정보 조회에 실패했습니다: $e');
    }
  }
}
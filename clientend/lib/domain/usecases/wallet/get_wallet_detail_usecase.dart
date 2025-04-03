import 'package:kkuk_kkuk/data/dtos/wallet/wallet_detail_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class GetWalletDetailUseCase {
  final IWalletRepository _walletRepository;

  GetWalletDetailUseCase(this._walletRepository);

  /// 지갑 상세 정보 조회
  Future<WalletDetailResponse> execute(int walletId) async {
    try {
      return await _walletRepository.getWalletDetail(walletId);
    } catch (e) {
      print('지갑 상세 정보 조회 실패: $e');
      throw Exception('지갑 상세 정보 조회에 실패했습니다: $e');
    }
  }
}
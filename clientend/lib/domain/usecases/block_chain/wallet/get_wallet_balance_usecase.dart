import 'package:kkuk_kkuk/domain/repositories/blockchain_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class GetWalletBalanceUseCase {
  final IBlockchainRepository _blockchainRepository;

  GetWalletBalanceUseCase(this._blockchainRepository);

  /// 지갑 주소의 잔액 조회
  Future<EtherAmount> execute(String address) async {
    try {
      return await _blockchainRepository.getBalance(address);
    } catch (e) {
      throw Exception('지갑 잔액 조회 중 오류가 발생했습니다: $e');
    }
  }
}

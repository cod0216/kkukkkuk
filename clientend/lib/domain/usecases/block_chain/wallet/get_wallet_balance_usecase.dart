import 'package:kkuk_kkuk/data/datasource/contracts/blockchain_client.dart';
import 'package:web3dart/web3dart.dart';

class GetWalletBalanceUseCase {
  final BlockchainClient _blockchainClient;

  GetWalletBalanceUseCase(this._blockchainClient);

  /// 지갑 주소의 잔액 조회
  Future<EtherAmount> execute(String address) async {
    try {
      return await _blockchainClient.getBalance(address);
    } catch (e) {
      throw Exception('지갑 잔액 조회 중 오류가 발생했습니다: $e');
    }
  }
}

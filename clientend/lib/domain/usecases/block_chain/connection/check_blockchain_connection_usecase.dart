import 'package:kkuk_kkuk/data/datasource/contracts/blockchain_client.dart';

class CheckBlockchainConnectionUseCase {
  final BlockchainClient _blockchainClient;

  CheckBlockchainConnectionUseCase(this._blockchainClient);

  /// 블록체인 네트워크 연결 확인
  Future<bool> execute() async {
    try {
      return await _blockchainClient.isConnected();
    } catch (e) {
      throw Exception('블록체인 네트워크 연결 확인 중 오류가 발생했습니다: $e');
    }
  }
}

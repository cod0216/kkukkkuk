import 'package:kkuk_kkuk/shared/blockchain/blockchain_client.dart';
import 'package:web3dart/web3dart.dart';

class GetWeb3ClientUseCase {
  final BlockchainClient _blockchainClient;

  GetWeb3ClientUseCase(this._blockchainClient);

  /// Web3Client 인스턴스 가져오기
  Web3Client execute() {
    try {
      return _blockchainClient.client;
    } catch (e) {
      throw Exception('Web3Client 인스턴스를 가져오는 중 오류가 발생했습니다: $e');
    }
  }
}

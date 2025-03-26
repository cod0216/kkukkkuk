import 'package:kkuk_kkuk/domain/repositories/blockchain_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class GetWeb3ClientUseCase {
  final IBlockchainRepository _blockchainRepository;

  GetWeb3ClientUseCase(this._blockchainRepository);

  /// Web3Client 인스턴스 가져오기
  Web3Client execute() {
    try {
      return _blockchainRepository.getClient();
    } catch (e) {
      throw Exception('Web3Client 인스턴스를 가져오는 중 오류가 발생했습니다: $e');
    }
  }
}

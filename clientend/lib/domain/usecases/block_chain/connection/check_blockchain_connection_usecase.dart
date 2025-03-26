import 'package:kkuk_kkuk/domain/repositories/blockchain_repository_interface.dart';

class CheckBlockchainConnectionUseCase {
  final IBlockchainRepository _blockchainRepository;

  CheckBlockchainConnectionUseCase(this._blockchainRepository);

  /// 블록체인 네트워크 연결 확인
  Future<bool> execute() async {
    try {
      return await _blockchainRepository.isConnected();
    } catch (e) {
      throw Exception('블록체인 네트워크 연결 확인 중 오류가 발생했습니다: $e');
    }
  }
}

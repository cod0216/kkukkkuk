import 'package:web3dart/web3dart.dart';

abstract class IBlockchainRepository {
  /// 블록체인 네트워크 연결 확인
  Future<bool> isConnected();

  /// 지갑 주소의 잔액 조회
  Future<EtherAmount> getBalance(String address);

  /// Web3Client 인스턴스 가져오기
  Web3Client getClient();

  /// 리소스 해제
  void dispose();
}

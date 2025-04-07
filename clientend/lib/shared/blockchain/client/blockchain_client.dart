import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/config/app_config.dart';

class BlockchainClient {
  final Web3Client client;
  final http.Client httpClient;
  final IOWebSocketChannel webSocketChannel;

  BlockchainClient._({
    required this.client,
    required this.httpClient,
    required this.webSocketChannel,
  });

  factory BlockchainClient() {
    final httpClient = http.Client();
    final webSocketChannel = IOWebSocketChannel.connect(
      AppConfig.blockchainWsUrl,
    ); // 변경
    final client = Web3Client(
      AppConfig.blockchainRpcUrl, // 변경
      httpClient,
      socketConnector: () => webSocketChannel.cast<String>(),
    );

    return BlockchainClient._(
      client: client,
      httpClient: httpClient,
      webSocketChannel: webSocketChannel,
    );
  }

  /// 연결 상태 확인
  Future<bool> isConnected() async {
    try {
      // 네트워크 ID를 가져와서 연결 상태 확인
      await client.getNetworkId();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<EtherAmount> getBalance(String address) async {
  //   final ethAddress = EthereumAddress.fromHex(address);
  //   return await client.getBalance(ethAddress);
  // }

  Future<String> sendTransaction({
    required Credentials credentials,
    required Transaction transaction,
  }) async {
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: AppConfig.blockchainChainId,
    );
  }

  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    return await client.getTransactionReceipt(txHash);
  }

  void dispose() {
    client.dispose();
    httpClient.close();
    webSocketChannel.sink.close();
  }
}

final blockchainClientProvider = Provider<BlockchainClient>((ref) {
  final client = BlockchainClient();
  ref.onDispose(() => client.dispose());
  return client;
});

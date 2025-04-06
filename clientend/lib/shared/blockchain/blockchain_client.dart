import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockchainClient {
  static const String rpcUrl = 'https://rpc.ssafy-blockchain.com';
  static const String wsUrl = 'wss://ws.ssafy-blockchain.com';
  static const int chainId = 31221;

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
    final webSocketChannel = IOWebSocketChannel.connect(wsUrl);
    final client = Web3Client(
      rpcUrl,
      httpClient,
      socketConnector: () => webSocketChannel.cast<String>(),
    );

    return BlockchainClient._(
      client: client,
      httpClient: httpClient,
      webSocketChannel: webSocketChannel,
    );
  }

  // Add this method if it doesn't already exist
  Future<bool> isConnected() async {
    try {
      // Simple check to see if we can get the network ID
      await client.getNetworkId();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<EtherAmount> getBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    return await client.getBalance(ethAddress);
  }

  Future<String> sendTransaction({
    required Credentials credentials,
    required Transaction transaction,
  }) async {
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: chainId,
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

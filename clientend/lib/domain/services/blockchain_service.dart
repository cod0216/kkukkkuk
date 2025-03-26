import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockchainService {
  static const String rpcUrl = 'https://rpc.ssafy-blockchain.com';
  static const String wsUrl = 'wss://ws.ssafy-blockchain.com';
  static const int chainId = 31221;

  late final Web3Client _client;
  late final http.Client _httpClient;
  late final IOWebSocketChannel _webSocketChannel;

  BlockchainService() {
    _httpClient = http.Client();
    _webSocketChannel = IOWebSocketChannel.connect(wsUrl);
    _client = Web3Client(
      rpcUrl,
      _httpClient,
      socketConnector: () => _webSocketChannel.cast<String>(),
    );
  }

  Web3Client get client => _client;

  Future<bool> isConnected() async {
    try {
      final clientVersion = await _client.getClientVersion();
      debugPrint('Connected to Ethereum client: $clientVersion');
      return true;
    } catch (e) {
      debugPrint('Failed to connect to Ethereum client: $e');
      return false;
    }
  }

  Future<EtherAmount> getBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    return await _client.getBalance(ethAddress);
  }

  void dispose() {
    _client.dispose();
    _httpClient.close();
    _webSocketChannel.sink.close();
  }
}

final blockchainServiceProvider = Provider<BlockchainService>((ref) {
  final service = BlockchainService();
  ref.onDispose(() => service.dispose());
  return service;
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kkuk_kkuk/domain/repositories/blockchain_repository_interface.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class BlockchainRepository implements IBlockchainRepository {
  static const String rpcUrl = 'https://rpc.ssafy-blockchain.com';
  static const String wsUrl = 'wss://ws.ssafy-blockchain.com';
  static const int chainId = 31221;

  late final Web3Client _client;
  late final http.Client _httpClient;
  late final IOWebSocketChannel _webSocketChannel;

  BlockchainRepository() {
    _httpClient = http.Client();
    _webSocketChannel = IOWebSocketChannel.connect(wsUrl);
    _client = Web3Client(
      rpcUrl,
      _httpClient,
      socketConnector: () => _webSocketChannel.cast<String>(),
    );
  }

  @override
  Web3Client getClient() => _client;

  @override
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

  @override
  Future<EtherAmount> getBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    return await _client.getBalance(ethAddress);
  }

  @override
  void dispose() {
    _client.dispose();
    _httpClient.close();
    _webSocketChannel.sink.close();
  }
}

final blockchainRepositoryProvider = Provider<BlockchainRepository>((ref) {
  final repository = BlockchainRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
});

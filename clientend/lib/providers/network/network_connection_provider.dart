import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/connection/blockchain_connection_usecase_providers.dart';

/// 네트워크 연결 상태
enum NetworkConnectionStatus {
  initial, // 초기 상태
  connecting, // 연결 중
  connected, // 연결됨
  failed, // 연결 실패
}

/// 네트워크 설정
class NetworkConfig {
  static const NETWORK_CONFIG = {
    'rpcUrl': 'https://rpc.ssafy-blockchain.com',
    'wsUrl': 'wss://ws.ssafy-blockchain.com',
    'chainId': '31221', // 10진수
    'chainName': 'SSAFY',
    'nativeCurrency': {'name': 'ETH', 'symbol': 'ETH', 'decimals': 18},
  };

  static const DEFAULT_GAS = 300000;
  static const DEFAULT_GAS_PRICE = '1';
}

/// 네트워크 연결 상태 관리 클래스
class NetworkConnectionState {
  final NetworkConnectionStatus status;
  final String? error;

  NetworkConnectionState({
    this.status = NetworkConnectionStatus.initial,
    this.error,
  });

  NetworkConnectionState copyWith({
    NetworkConnectionStatus? status,
    String? error,
  }) {
    return NetworkConnectionState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

/// 네트워크 연결 상태 관리 노티파이어
class NetworkConnectionNotifier extends StateNotifier<NetworkConnectionState> {
  final Ref ref;

  NetworkConnectionNotifier(this.ref) : super(NetworkConnectionState());

  /// 블록체인 네트워크 연결
  Future<bool> connectToNetwork() async {
    state = state.copyWith(
      status: NetworkConnectionStatus.connecting,
      error: null,
    );

    try {
      final checkConnectionUseCase = ref.read(
        checkBlockchainConnectionUseCaseProvider,
      );
      final isConnected = await checkConnectionUseCase.execute();

      if (isConnected) {
        state = state.copyWith(status: NetworkConnectionStatus.connected);
        debugPrint('블록체인 네트워크에 연결되었습니다.');
        return true;
      } else {
        state = state.copyWith(
          status: NetworkConnectionStatus.failed,
          error: '블록체인 네트워크 연결에 실패했습니다.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: NetworkConnectionStatus.failed,
        error: '블록체인 네트워크 연결 중 오류가 발생했습니다: $e',
      );
      return false;
    }
  }

  /// 연결 상태 초기화
  void reset() {
    state = NetworkConnectionState();
  }
}

/// 네트워크 연결 프로바이더
final networkConnectionProvider =
    StateNotifierProvider<NetworkConnectionNotifier, NetworkConnectionState>((
      ref,
    ) {
      return NetworkConnectionNotifier(ref);
    });

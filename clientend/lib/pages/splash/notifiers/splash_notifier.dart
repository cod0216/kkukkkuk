import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/splash/states/splash_status.dart';
import 'package:kkuk_kkuk/shared/blockchain/client/blockchain_client.dart';

class SplashState {
  final SplashStatus status;
  final String? error;

  SplashState({this.status = SplashStatus.initializing, this.error});

  SplashState copyWith({SplashStatus? status, String? error}) {
    return SplashState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class SplashNotifier extends StateNotifier<SplashState> {
  final Ref ref;

  SplashNotifier(this.ref) : super(SplashState());

  Future<void> initializeAppAndConnect() async {
    state = state.copyWith(status: SplashStatus.connecting);
    try {
      // 블록체인 클라이언트 가져오기
      final blockchainClient = ref.read(blockchainClientProvider);

      // 블록체인 연결
      final isConnected = await blockchainClient.isConnected();

      if (isConnected) {
        state = state.copyWith(status: SplashStatus.connected);
      } else {
        state = state.copyWith(
          status: SplashStatus.failed,
          error: "블록체인 네트워크 연결에 실패했습니다.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: SplashStatus.failed,
        error: "초기화 중 오류 발생: ${e.toString()}",
      );
    }
  }

  // 재시도 함수
  Future<void> retryConnection() async {
    await initializeAppAndConnect();
  }
}

final splashNotifierProvider =
    StateNotifierProvider<SplashNotifier, SplashState>((ref) {
      return SplashNotifier(ref);
    });

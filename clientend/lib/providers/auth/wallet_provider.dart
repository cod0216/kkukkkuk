import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';

enum WalletStatus { initial, creating, created, error }

class WalletState {
  final WalletStatus status;
  final String? walletAddress;
  final String? error;

  WalletState({
    this.status = WalletStatus.initial,
    this.walletAddress,
    this.error,
  });

  WalletState copyWith({
    WalletStatus? status,
    String? walletAddress,
    String? error,
  }) {
    return WalletState(
      status: status ?? this.status,
      walletAddress: walletAddress ?? this.walletAddress,
      error: error ?? this.error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;

  WalletNotifier(this.ref) : super(WalletState());

  Future<void> createWallet() async {
    state = state.copyWith(status: WalletStatus.creating, error: null);

    try {
      // TODO: Implement actual wallet creation
      await Future.delayed(const Duration(seconds: 2));
      
      state = state.copyWith(
        status: WalletStatus.created,
        walletAddress: '0x123...abc', // Example address
      );
      
      ref.read(authCoordinatorProvider.notifier).moveToPinSetup();
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 생성에 실패했습니다.',
      );
    }
  }

  void reset() {
    state = WalletState();
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref);
});

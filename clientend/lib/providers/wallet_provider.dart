import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WalletCreationState {
  initial,
  creating,
  created,
  error,
}

class WalletState {
  final WalletCreationState creationState;
  final String? errorMessage;
  final String? walletAddress;

  WalletState({
    this.creationState = WalletCreationState.initial,
    this.errorMessage,
    this.walletAddress,
  });

  WalletState copyWith({
    WalletCreationState? creationState,
    String? errorMessage,
    String? walletAddress,
  }) {
    return WalletState(
      creationState: creationState ?? this.creationState,
      errorMessage: errorMessage ?? this.errorMessage,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(WalletState());

  Future<void> createWallet() async {
    state = state.copyWith(creationState: WalletCreationState.creating);
    
    try {
      // TODO: 지갑 생성 로직 구현
      // 실제 지갑 생성 로직은 나중에 구현
      await Future.delayed(const Duration(seconds: 2)); // 로딩 시뮬레이션
      
      // 임시 지갑 주소
      const String mockWalletAddress = "0x1234...5678";
      
      state = state.copyWith(
        creationState: WalletCreationState.created,
        walletAddress: mockWalletAddress,
      );
    } catch (e) {
      state = state.copyWith(
        creationState: WalletCreationState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = WalletState();
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});
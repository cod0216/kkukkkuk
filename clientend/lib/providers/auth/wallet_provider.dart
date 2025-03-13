import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/services/auth_service.dart';

enum WalletStatus {
  initial,
  generating,
  generated,
  settingPin,
  confirmingPin,
  encrypting,
  saving,
  completed,
  error,
}

class WalletState {
  final WalletStatus status;
  final String? walletAddress;
  final String? privateKey;
  final String? firstPin;
  final String? currentPin;
  final String? error;

  WalletState({
    this.status = WalletStatus.initial,
    this.walletAddress,
    this.privateKey,
    this.firstPin = '',
    this.currentPin = '',
    this.error,
  });

  WalletState copyWith({
    WalletStatus? status,
    String? walletAddress,
    String? privateKey,
    String? firstPin,
    String? currentPin,
    String? error,
  }) {
    return WalletState(
      status: status ?? this.status,
      walletAddress: walletAddress ?? this.walletAddress,
      privateKey: privateKey ?? this.privateKey,
      firstPin: firstPin ?? this.firstPin,
      currentPin: currentPin ?? this.currentPin,
      error: error ?? this.error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;
  final AuthService _authService;

  WalletNotifier(this.ref, this._authService) : super(WalletState());

  Future<void> createWallet() async {
    state = state.copyWith(status: WalletStatus.generating, error: null);

    try {
      // Generate private key
      final privateKey = await _authService.generatePrivateKey();

      // Create wallet from private key
      final walletAddress = await _authService.createWalletFromPrivateKey(
        privateKey,
      );

      state = state.copyWith(
        status: WalletStatus.settingPin,
        walletAddress: walletAddress,
        privateKey: privateKey,
      );
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 생성에 실패했습니다.',
      );
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void addPinDigit(String digit) {
    if (state.status == WalletStatus.settingPin) {
      if ((state.firstPin?.length ?? 0) < 6) {
        state = state.copyWith(
          firstPin: (state.firstPin ?? '') + digit,
          error: null,
        );
        if ((state.firstPin?.length ?? 0) == 6) {
          state = state.copyWith(status: WalletStatus.confirmingPin);
        }
      }
    } else if (state.status == WalletStatus.confirmingPin) {
      if ((state.currentPin?.length ?? 0) < 6) {
        state = state.copyWith(
          currentPin: (state.currentPin ?? '') + digit,
          error: null,
        );
        if ((state.currentPin?.length ?? 0) == 6) {
          _validatePinAndCompleteWallet();
        }
      }
    }
  }

  void deletePinDigit() {
    if (state.status == WalletStatus.settingPin &&
        (state.firstPin?.isNotEmpty ?? false)) {
      state = state.copyWith(
        firstPin: state.firstPin!.substring(0, state.firstPin!.length - 1),
      );
    } else if (state.status == WalletStatus.confirmingPin &&
        (state.currentPin?.isNotEmpty ?? false)) {
      state = state.copyWith(
        currentPin: state.currentPin!.substring(
          0,
          state.currentPin!.length - 1,
        ),
      );
    }
  }

  Future<void> _validatePinAndCompleteWallet() async {
    if (state.firstPin == state.currentPin) {
      try {
        state = state.copyWith(status: WalletStatus.encrypting);

        // Encrypt private key with PIN
        final encryptedPrivateKey = await _authService.encryptPrivateKey(
          state.privateKey!,
          state.firstPin!,
        );

        state = state.copyWith(status: WalletStatus.saving);

        // Save encrypted wallet to server
        await _authService.saveEncryptedWallet(
          state.walletAddress!,
          encryptedPrivateKey,
        );

        state = state.copyWith(status: WalletStatus.completed);
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } catch (e) {
        state = state.copyWith(
          status: WalletStatus.error,
          error: '지갑 저장에 실패했습니다.',
        );
      }
    } else {
      state = state.copyWith(
        status: WalletStatus.settingPin,
        currentPin: '',
        error: 'PIN이 일치하지 않습니다.',
      );
    }
  }

  void reset() {
    state = WalletState();
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  return WalletNotifier(ref, authService);
});

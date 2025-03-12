import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';

enum PinSetupStatus { firstEntry, confirming, completed, error }

class PinState {
  final PinSetupStatus status;
  final String firstPin;
  final String currentPin;
  final String? error;

  PinState({
    this.status = PinSetupStatus.firstEntry,
    this.firstPin = '',
    this.currentPin = '',
    this.error,
  });

  PinState copyWith({
    PinSetupStatus? status,
    String? firstPin,
    String? currentPin,
    String? error,
  }) {
    return PinState(
      status: status ?? this.status,
      firstPin: firstPin ?? this.firstPin,
      currentPin: currentPin ?? this.currentPin,
      error: error ?? this.error,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  final Ref ref;

  PinNotifier(this.ref) : super(PinState());

  void addDigit(String digit) {
    if (state.status == PinSetupStatus.firstEntry) {
      if (state.firstPin.length < 6) {
        state = state.copyWith(
          firstPin: state.firstPin + digit,
          error: null,
        );
        if (state.firstPin.length == 6) {
          state = state.copyWith(status: PinSetupStatus.confirming);
        }
      }
    } else if (state.status == PinSetupStatus.confirming) {
      if (state.currentPin.length < 6) {
        state = state.copyWith(
          currentPin: state.currentPin + digit,
          error: null,
        );
        if (state.currentPin.length == 6) {
          _validatePin();
        }
      }
    }
  }

  void deleteDigit() {
    if (state.status == PinSetupStatus.firstEntry && state.firstPin.isNotEmpty) {
      state = state.copyWith(
        firstPin: state.firstPin.substring(0, state.firstPin.length - 1),
      );
    } else if (state.status == PinSetupStatus.confirming && state.currentPin.isNotEmpty) {
      state = state.copyWith(
        currentPin: state.currentPin.substring(0, state.currentPin.length - 1),
      );
    }
  }

  Future<void> _validatePin() async {
    if (state.firstPin == state.currentPin) {
      try {
        // TODO: Implement actual PIN storage
        await Future.delayed(const Duration(seconds: 1));
        state = state.copyWith(status: PinSetupStatus.completed);
        ref.read(authCoordinatorProvider.notifier).completeAuth();
      } catch (e) {
        state = state.copyWith(
          status: PinSetupStatus.error,
          error: 'PIN 저장에 실패했습니다.',
        );
      }
    } else {
      state = state.copyWith(
        status: PinSetupStatus.firstEntry,
        currentPin: '',
        error: 'PIN이 일치하지 않습니다.',
      );
    }
  }

  void reset() {
    state = PinState();
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier(ref);
});

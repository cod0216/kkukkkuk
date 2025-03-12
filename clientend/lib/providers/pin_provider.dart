import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PinSetupState { initial, firstEntry, confirming, success, error }

class PinState {
  final PinSetupState setupState;
  final String pin;
  final String? confirmPin;
  final String? errorMessage;

  PinState({
    this.setupState = PinSetupState.initial,
    this.pin = '',
    this.confirmPin,
    this.errorMessage,
  });

  PinState copyWith({
    PinSetupState? setupState,
    String? pin,
    String? confirmPin,
    String? errorMessage,
  }) {
    return PinState(
      setupState: setupState ?? this.setupState,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  PinNotifier() : super(PinState(setupState: PinSetupState.firstEntry));

  void addDigit(String digit) {
    if (state.pin.length < 6) {
      final newPin = state.pin + digit;
      state = state.copyWith(pin: newPin);

      // 6자리가 모두 입력되었을 때
      if (newPin.length == 6) {
        _handleCompleteEntry();
      }
    }
  }

  void deleteDigit() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
    }
  }

  void _handleCompleteEntry() {
    // 첫 번째 입력인 경우
    if (state.setupState == PinSetupState.firstEntry) {
      Future.delayed(const Duration(milliseconds: 300), () {
        state = state.copyWith(
          setupState: PinSetupState.confirming,
          confirmPin: state.pin,
          pin: '',
        );
      });
    }
    // 확인 입력인 경우
    else if (state.setupState == PinSetupState.confirming) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (state.pin == state.confirmPin) {
          state = state.copyWith(setupState: PinSetupState.success);
          // TODO: 서버에 PIN 전송 로직 추가
          _savePinToServer(state.pin);
        } else {
          state = state.copyWith(
            setupState: PinSetupState.error,
            pin: '',
            errorMessage: 'PIN이 일치하지 않습니다. 다시 입력해주세요.',
          );

          // 잠시 후 다시 확인 단계로 전환
          Future.delayed(const Duration(seconds: 2), () {
            state = state.copyWith(
              setupState: PinSetupState.confirming,
              errorMessage: null,
            );
          });
        }
      });
    }
  }

  // PIN 서버에 저장
  Future<void> _savePinToServer(String pin) async {
    // TODO: 서버에 PIN 전송 로직 구현
    try {
      // 서버 통신 로직
      await Future.delayed(const Duration(seconds: 1)); // 임시 지연
    } catch (e) {
      state = state.copyWith(
        setupState: PinSetupState.error,
        errorMessage: '서버 통신 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = PinState(setupState: PinSetupState.firstEntry);
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier();
});

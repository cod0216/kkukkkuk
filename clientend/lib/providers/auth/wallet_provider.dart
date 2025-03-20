import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/services/wallet_service.dart';

/// 지갑 생성 및 설정 단계
enum WalletStatus {
  initial, // 초기 상태
  generating, // 지갑 생성 중
  generated, // 지갑 생성 완료
  settingPin, // PIN 설정 중
  confirmingPin, // PIN 확인 중
  encrypting, // 개인키 암호화 중
  saving, // 지갑 정보 저장 중
  completed, // 모든 과정 완료
  error, // 오류 발생
}

/// 지갑 상태 관리 클래스
class WalletState {
  final WalletStatus status;
  final String? walletAddress;
  final String? privateKey;
  final String? publicKey;
  final String? did;
  final int? walletId;
  final String? firstPin;
  final String? currentPin;
  final String? error;

  WalletState({
    this.status = WalletStatus.initial,
    this.walletAddress,
    this.privateKey,
    this.publicKey,
    this.did,
    this.walletId,
    this.firstPin = '',
    this.currentPin = '',
    this.error,
  });

  /// 상태 복사 메서드
  WalletState copyWith({
    WalletStatus? status,
    String? walletAddress,
    String? privateKey,
    String? firstPin,
    String? currentPin,
    String? error,
    String? publicKey,
    String? did,
    int? walletId,
  }) {
    return WalletState(
      status: status ?? this.status,
      walletAddress: walletAddress ?? this.walletAddress,
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
      did: did ?? this.did,
      walletId: walletId ?? this.walletId,
      firstPin: firstPin ?? this.firstPin,
      currentPin: currentPin ?? this.currentPin,
      error: error ?? this.error,
    );
  }
}

/// 지갑 상태 관리 노티파이어
class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;
  final WalletService _walletService;

  WalletNotifier(this.ref, this._walletService) : super(WalletState());

  /// 새 지갑 생성
  Future<void> createWallet() async {
    state = state.copyWith(status: WalletStatus.generating, error: null);

    try {
      // 지갑 서비스를 통한 새 지갑 생성
      final walletData = await _walletService.createWallet();

      state = state.copyWith(
        status: WalletStatus.settingPin,
        walletAddress: walletData['address'],
        privateKey: walletData['privateKey'],
        publicKey: walletData['publicKey'],
        did: walletData['did'],
      );
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 생성에 실패했습니다.',
      );
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  /// PIN 확인 및 지갑 등록 처리
  Future<void> confirmPin(String pin) async {
    if (state.firstPin != pin) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: 'PIN이 일치하지 않습니다.',
      );
      return;
    }

    try {
      state = state.copyWith(status: WalletStatus.encrypting);

      // 개인키 암호화
      final encryptedPrivateKey = await _walletService.encryptPrivateKey(
        state.privateKey!,
        pin,
      );

      state = state.copyWith(status: WalletStatus.saving);

      // 서버에 지갑 등록
      final response = await _walletService.registerWalletToServer(
        did: state.did!,
        address: state.walletAddress!,
        encryptedPrivateKey: encryptedPrivateKey,
        publicKey: state.publicKey!,
      );

      state = state.copyWith(
        status: WalletStatus.completed,
        walletId: response.data.id,
      );

      // 인증 완료 처리
      ref.read(authCoordinatorProvider.notifier).completeAuth();
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 등록에 실패했습니다.',
      );
    }
  }

  // confirmPin 메서드 제거

  /// PIN 번호 입력 처리
  void addPinDigit(String digit) {
    if (state.status == WalletStatus.settingPin) {
      if ((state.firstPin?.length ?? 0) < 6) {
        state = state.copyWith(
          firstPin: (state.firstPin ?? '') + digit,
          error: null,
        );
        if ((state.firstPin?.length ?? 0) == 6) {
          state = state.copyWith(
            status: WalletStatus.confirmingPin,
            currentPin: '', // 두 번째 PIN 입력 시작 시 초기화
          );
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

  /// PIN 검증 및 지갑 설정 완료 처리
  Future<void> _validatePinAndCompleteWallet() async {
    if (state.firstPin != state.currentPin) {
      state = state.copyWith(
        status: WalletStatus.settingPin,
        currentPin: '',
        firstPin: '', // 첫 번째 PIN도 초기화
        error: 'PIN이 일치하지 않습니다.',
      );
      return;
    }

    try {
      state = state.copyWith(status: WalletStatus.encrypting);

      final encryptedPrivateKey = await _walletService.encryptPrivateKey(
        state.privateKey!,
        state.firstPin!,
      );

      state = state.copyWith(status: WalletStatus.saving);

      final response = await _walletService.registerWalletToServer(
        did: state.did!,
        address: state.walletAddress!,
        encryptedPrivateKey: encryptedPrivateKey,
        publicKey: state.publicKey!,
      );

      await _walletService.saveEncryptedWallet(
        state.walletAddress!,
        encryptedPrivateKey,
      );

      state = state.copyWith(
        status: WalletStatus.completed,
        walletId: response.data.id,
      );

      ref.read(authCoordinatorProvider.notifier).completeAuth();
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 등록에 실패했습니다.',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    state = WalletState();
  }

  /// PIN 번호 삭제 처리
  void deletePinDigit() {
    if (state.status == WalletStatus.settingPin) {
      if (state.firstPin?.isNotEmpty ?? false) {
        state = state.copyWith(
          firstPin: state.firstPin!.substring(0, state.firstPin!.length - 1),
          error: null,
        );
      }
    } else if (state.status == WalletStatus.confirmingPin) {
      if (state.currentPin?.isNotEmpty ?? false) {
        state = state.copyWith(
          currentPin: state.currentPin!.substring(
            0,
            state.currentPin!.length - 1,
          ),
          error: null,
        );
      }
    }
  }
}

/// 지갑 프로바이더
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  final walletService = ref.watch(walletServiceProvider);
  return WalletNotifier(ref, walletService);
});

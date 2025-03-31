import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/mnemonic_usecase_provider.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/wallet/wallet_usecase_providers.dart';

/// 니모닉 지갑 생성 및 설정 단계
enum WalletStatus {
  initial, // 초기 상태
  walletChoice, // 지갑 생성/복구 선택
  generatingMnemonic, // 니모닉 생성 중
  mnemonicGenerated, // 니모닉 생성 완료
  mnemonicConfirmation, // 니모닉 확인 중
  recoveringWallet, // 지갑 복구 중
  creatingWallet, // 지갑 생성 중
  registeringWallet, // 지갑 등록 중
  completed, // 모든 과정 완료
  error, // 오류 발생
}

/// 니모닉 지갑 상태 관리 클래스
class WalletState {
  final WalletStatus status;
  final WalletStatus? previousStatus; // Add this to track previous state
  final List<String>? mnemonicWords; // 니모닉 단어 목록
  final List<int>? selectedWordIndices; // 선택된 니모닉 단어 인덱스
  final String? walletAddress;
  final String? publicKey;
  final String? did;
  final int? walletId;
  final String? error;
  final int accountIndex; // HD 지갑 계정 인덱스

  WalletState({
    this.status = WalletStatus.initial,
    this.previousStatus,
    this.mnemonicWords,
    this.selectedWordIndices,
    this.walletAddress,
    this.publicKey,
    this.did,
    this.walletId,
    this.error,
    this.accountIndex = 0,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletStatus? previousStatus,
    List<String>? mnemonicWords,
    List<int>? selectedWordIndices,
    String? walletAddress,
    String? publicKey,
    String? did,
    int? walletId,
    String? error,
    int? accountIndex,
  }) {
    return WalletState(
      status: status ?? this.status,
      previousStatus: previousStatus ?? this.previousStatus,
      mnemonicWords: mnemonicWords ?? this.mnemonicWords,
      selectedWordIndices: selectedWordIndices ?? this.selectedWordIndices,
      walletAddress: walletAddress ?? this.walletAddress,
      publicKey: publicKey ?? this.publicKey,
      did: did ?? this.did,
      walletId: walletId ?? this.walletId,
      error: error ?? this.error,
      accountIndex: accountIndex ?? this.accountIndex,
    );
  }
}

/// 니모닉 지갑 상태 관리 노티파이어
class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;

  WalletNotifier(this.ref) : super(WalletState());

  /// 니모닉 생성
  Future<void> generateMnemonic() async {
    state = state.copyWith(
      status: WalletStatus.generatingMnemonic,
      error: null,
    );

    try {
      final generateKoreanMnemonicUseCase = ref.read(
        generateMnemonicUseCaseProvider,
      );

      final mnemonicWords = await generateKoreanMnemonicUseCase.execute(
        strength: 128,
      ); // 12단어

      state = state.copyWith(
        status: WalletStatus.mnemonicGenerated,
        mnemonicWords: mnemonicWords,
        selectedWordIndices: [],
      );
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '니모닉 생성에 실패했습니다: $e',
      );
    }
  }

  /// 니모닉 단어 선택
  void selectMnemonicWord(int index) {
    if (state.selectedWordIndices == null) return;
    if (state.selectedWordIndices!.contains(index))
      return; // Prevent selecting same word twice

    // Only allow selection if it's the next word in sequence
    if (state.selectedWordIndices!.length <
        (state.mnemonicWords?.length ?? 0)) {
      final updatedIndices = List<int>.from(state.selectedWordIndices!);
      updatedIndices.add(index);
      state = state.copyWith(selectedWordIndices: updatedIndices);
    }
  }

  /// Remove the last selected word
  void removeLastSelectedWord() {
    if (state.selectedWordIndices == null || state.selectedWordIndices!.isEmpty)
      return;

    final updatedIndices = List<int>.from(state.selectedWordIndices!);
    updatedIndices.removeLast();
    state = state.copyWith(selectedWordIndices: updatedIndices);
  }

  /// 니모닉 확인
  Future<void> confirmMnemonic() async {
    if (state.mnemonicWords == null || state.selectedWordIndices == null) {
      return;
    }

    // 선택된 단어들로 니모닉 문장 생성
    final selectedWords =
        state.selectedWordIndices!
            .map((index) => state.mnemonicWords![index])
            .toList();
    final mnemonic = selectedWords.join(' ');

    final validateKoreanMnemonicUseCase = ref.read(
      validateMnemonicUseCaseProvider,
    );
    // 니모닉 검증
    final isValid = validateKoreanMnemonicUseCase.execute(mnemonic);

    if (!isValid) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '잘못된 니모닉 단어 조합입니다.',
      );
      return;
    }

    try {
      state = state.copyWith(status: WalletStatus.creatingWallet);

      // 지갑 생성 및 등록 진행
      await createAndRegisterWallet(mnemonic);
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '니모닉 저장에 실패했습니다: $e',
      );
    }
  }

  /// 지갑 생성 및 등록
  Future<void> createAndRegisterWallet(String mnemonic) async {
    try {
      // 지갑 생성
      final createWalletFromMnemonicUseCase = ref.read(
        createWalletFromMnemonicUseCaseProvider,
      );
      final wallet = await createWalletFromMnemonicUseCase.execute(
        mnemonic,
        accountIndex: state.accountIndex,
      );

      state = state.copyWith(
        walletAddress: wallet['address'],
        publicKey: wallet['publicKey'],
        did: wallet['did'],
      );

      state = state.copyWith(status: WalletStatus.registeringWallet);

      // 지갑 생성
      final registerWalletUseCase = ref.read(registerWalletUseCaseProvider);
      // 지갑 등록
      final registeredWallet = await registerWalletUseCase.execute(
        did: wallet['did'] ?? '',
        address: wallet['address'] ?? '',
        encryptedPrivateKey: '',
        publicKey: wallet['publicKey'] ?? '',
      );

      state = state.copyWith(
        status: WalletStatus.completed,
        walletId: registeredWallet.toJson()['id'] ?? 0,
      );

      // 네트워크 연결 단계로 이동 (authCoordinatorProvider에서 authControllerProvider로 변경)
      ref.read(authControllerProvider.notifier).moveToNetworkConnection();
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 생성 및 등록에 실패했습니다: $e',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    state = WalletState();
  }

  /// 지갑 복구 화면으로 전환
  void startWalletRecovery() {
    state = state.copyWith(
      status: WalletStatus.recoveringWallet,
      previousStatus: state.status, // Save current status
      error: null,
    );
  }

  /// 니모닉 확인 단계로 진행
  void startMnemonicConfirmation() {
    if (state.status == WalletStatus.mnemonicGenerated &&
        state.mnemonicWords != null) {
      state = state.copyWith(
        status: WalletStatus.mnemonicConfirmation,
        previousStatus: state.status, // Save current status
        selectedWordIndices: [], // Reset selected indices
        error: null,
      );
    }
  }

  /// 니모닉으로 지갑 복구
  Future<void> recoverWallet(String mnemonic) async {
    if (mnemonic.isEmpty) {
      state = state.copyWith(
        status: WalletStatus.error,
        previousStatus: state.status, // Save current status
        error: '니모닉을 입력해주세요.',
      );
      return;
    }

    state = state.copyWith(
      status: WalletStatus.creatingWallet,
      previousStatus: state.status, // Save current status
      error: null,
    );

    try {
      // 니모닉 검증
      final validateKoreanMnemonicUseCase = ref.read(
        validateMnemonicUseCaseProvider,
      );
      final isValid = validateKoreanMnemonicUseCase.execute(mnemonic);

      if (!isValid) {
        state = state.copyWith(
          status: WalletStatus.error,
          error: '유효하지 않은 니모닉입니다. 다시 확인해주세요.',
        );
        return;
      }

      state = state.copyWith(status: WalletStatus.creatingWallet);

      // 지갑 생성 및 등록 진행
      await createAndRegisterWallet(mnemonic);
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 복구에 실패했습니다: $e',
      );
    }
  }

  /// 이전 상태로 돌아가기
  void returnToPreviousState() {
    // If there's a previous state, go back to it
    if (state.previousStatus != null) {
      state = state.copyWith(status: state.previousStatus, error: null);
    } else {
      // If no previous state is recorded, go to wallet choice
      state = state.copyWith(status: WalletStatus.walletChoice, error: null);
    }
  }
}

/// 니모닉 지갑 프로바이더
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier(ref);
});

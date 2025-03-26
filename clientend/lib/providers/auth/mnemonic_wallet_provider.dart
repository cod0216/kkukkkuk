import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/mnemonic_usecase_provider.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/wallet/wallet_usecase_providers.dart';

/// 니모닉 지갑 생성 및 설정 단계
enum MnemonicWalletStatus {
  initial, // 초기 상태
  walletChoice, // 지갑 생성/복구 선택
  generatingMnemonic, // 니모닉 생성 중
  mnemonicGenerated, // 니모닉 생성 완료
  mnemonicConfirmation, // 니모닉 확인 중
  creatingWallet, // 지갑 생성 중
  registeringWallet, // 지갑 등록 중
  completed, // 모든 과정 완료
  error, // 오류 발생
}

/// 니모닉 지갑 상태 관리 클래스
class MnemonicWalletState {
  final MnemonicWalletStatus status;
  final List<String>? mnemonicWords; // 니모닉 단어 목록
  final List<int>? selectedWordIndices; // 선택된 니모닉 단어 인덱스
  final String? walletAddress;
  final String? publicKey;
  final String? did;
  final int? walletId;
  final String? error;
  final int accountIndex; // HD 지갑 계정 인덱스

  MnemonicWalletState({
    this.status = MnemonicWalletStatus.initial,
    this.mnemonicWords,
    this.selectedWordIndices,
    this.walletAddress,
    this.publicKey,
    this.did,
    this.walletId,
    this.error,
    this.accountIndex = 0,
  });

  MnemonicWalletState copyWith({
    MnemonicWalletStatus? status,
    List<String>? mnemonicWords,
    List<int>? selectedWordIndices,
    String? walletAddress,
    String? publicKey,
    String? did,
    int? walletId,
    String? error,
    int? accountIndex,
  }) {
    return MnemonicWalletState(
      status: status ?? this.status,
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
class MnemonicWalletNotifier extends StateNotifier<MnemonicWalletState> {
  final Ref ref;

  MnemonicWalletNotifier(this.ref) : super(MnemonicWalletState());

  /// 니모닉 생성
  Future<void> generateMnemonic() async {
    state = state.copyWith(
      status: MnemonicWalletStatus.generatingMnemonic,
      error: null,
    );

    try {
      final generateKoreanMnemonicUseCase = ref.read(
        generateKoreanMnemonicUseCaseProvider,
      );

      final mnemonicWords = await generateKoreanMnemonicUseCase.execute(
        strength: 128,
      ); // 12단어

      state = state.copyWith(
        status: MnemonicWalletStatus.mnemonicGenerated,
        mnemonicWords: mnemonicWords,
        selectedWordIndices: [],
      );
    } catch (e) {
      state = state.copyWith(
        status: MnemonicWalletStatus.error,
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
      validateKoreanMnemonicUseCaseProvider,
    );
    // 니모닉 검증
    final isValid = validateKoreanMnemonicUseCase.execute(mnemonic);

    if (!isValid) {
      state = state.copyWith(
        status: MnemonicWalletStatus.error,
        error: '잘못된 니모닉 단어 조합입니다.',
      );
      return;
    }

    try {
      // 니모닉 안전하게 저장
      final saveMnemonicUseCase = ref.read(saveMnemonicUseCaseProvider);
      await saveMnemonicUseCase.execute(mnemonic);

      state = state.copyWith(status: MnemonicWalletStatus.creatingWallet);

      // 지갑 생성 및 등록 진행
      await createAndRegisterWallet(mnemonic);
    } catch (e) {
      state = state.copyWith(
        status: MnemonicWalletStatus.error,
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

      state = state.copyWith(status: MnemonicWalletStatus.registeringWallet);

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
        status: MnemonicWalletStatus.completed,
        walletId: registeredWallet.toJson()['id'] ?? 0,
      );

      // 네트워크 연결 단계로 이동
      ref.read(authCoordinatorProvider.notifier).moveToNetworkConnection();
    } catch (e) {
      state = state.copyWith(
        status: MnemonicWalletStatus.error,
        error: '지갑 생성 및 등록에 실패했습니다: $e',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    state = MnemonicWalletState();
  }

  /// 니모닉 확인 단계로 진행
  void startMnemonicConfirmation() {
    if (state.status == MnemonicWalletStatus.mnemonicGenerated &&
        state.mnemonicWords != null) {
      state = state.copyWith(
        status: MnemonicWalletStatus.mnemonicConfirmation,
        selectedWordIndices: [], // Reset selected indices
        error: null,
      );
    }
  }
}

/// 니모닉 지갑 프로바이더
final mnemonicWalletProvider =
    StateNotifierProvider<MnemonicWalletNotifier, MnemonicWalletState>((ref) {
      return MnemonicWalletNotifier(ref);
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/wallet/model/mnemonic_usecase_provider.dart';
import 'package:kkuk_kkuk/features/wallet/model/wallet_usecase_providers.dart';
import 'package:kkuk_kkuk/features/auth/model/providers/auth_view_model.dart';

/// 니모닉 지갑 생성 및 설정 단계
enum WalletStatus {
  initial, // 초기 상태
  walletChoice, // 지갑 생성/복구 선택
  generatingMnemonic, // 니모닉 생성 중
  mnemonicGenerated, // 니모닉 생성 완료
  mnemonicConfirmation, // 니모닉 확인 중
  recoveringWallet, // 지갑 복구 중
  creatingWallet, // 지갑 생성 중
  namingWallet, // 지갑 이름 설정 중
  registeringWallet, // 지갑 등록 중
  completed, // 모든 과정 완료
  error, // 오류 발생
}

/// 니모닉 지갑 상태 관리 클래스
class WalletState {
  // 기존 코드 유지
  final WalletStatus status;
  final WalletStatus? previousStatus;
  final List<String>? mnemonicWords;
  final List<int>? selectedWordIndices;
  final String? walletAddress;
  final String? publicKey;
  final String? did;
  final int? walletId;
  final String? error;
  final int accountIndex;
  final String? walletName; // 지갑 이름 추가

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
    this.walletName,
  });

  // 기존 copyWith 메서드 유지
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
    String? walletName,
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
      walletName: walletName ?? this.walletName,
    );
  }
}

/// 지갑 생성/등록 결과를 담는 클래스
class WalletResult {
  final bool success;
  final String? error;
  final int? walletId;
  final String? walletAddress;
  final bool needsNaming; // 이름 설정 필요 여부 추가

  WalletResult({
    required this.success,
    this.error,
    this.walletId,
    this.walletAddress,
    this.needsNaming = false,
  });
}

/// 니모닉 지갑 상태 관리 노티파이어
class WalletViewModel extends StateNotifier<WalletState> {
  final Ref ref;

  WalletViewModel(this.ref) : super(WalletState());

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

  // 기존 코드 유지 (selectMnemonicWord, removeLastSelectedWord)
  void selectMnemonicWord(int index) {
    // 기존 코드 유지
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

  void removeLastSelectedWord() {
    // 기존 코드 유지
    if (state.selectedWordIndices == null || state.selectedWordIndices!.isEmpty)
      return;

    final updatedIndices = List<int>.from(state.selectedWordIndices!);
    updatedIndices.removeLast();
    state = state.copyWith(selectedWordIndices: updatedIndices);
  }

  /// 니모닉 확인 - 결과를 반환하도록 수정
  Future<WalletResult> confirmMnemonic() async {
    if (state.mnemonicWords == null || state.selectedWordIndices == null) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '니모닉 단어가 없습니다.',
      );
      return WalletResult(success: false, error: '니모닉 단어가 없습니다.');
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
      return WalletResult(success: false, error: '잘못된 니모닉 단어 조합입니다.');
    }

    try {
      state = state.copyWith(status: WalletStatus.creatingWallet);

      // 지갑 생성 및 등록 진행
      return await createAndRegisterWallet(mnemonic);
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '니모닉 저장에 실패했습니다: $e',
      );
      return WalletResult(success: false, error: '니모닉 저장에 실패했습니다: $e');
    }
  }

  /// 지갑 생성 및 등록 - 결과를 반환하도록 수정
  Future<WalletResult> createAndRegisterWallet(String mnemonic) async {
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

      // 사용자의 지갑 목록에서 중복 확인
      final authState = ref.read(authViewModelProvider);
      final userWallets = authState.user?.wallets;

      // 중복 지갑 확인
      if (userWallets != null && userWallets.isNotEmpty) {
        final isDuplicate = userWallets.any(
          (existingWallet) =>
              existingWallet.address.toLowerCase() ==
                  wallet['address']?.toLowerCase() ||
              existingWallet.name.toLowerCase() == wallet['did']?.toLowerCase(),
        );

        if (isDuplicate) {
          // 이미 등록된 지갑이 있으면 등록 과정 건너뛰기
          print('이미 등록된 지갑입니다. 서버 등록 과정을 건너뜁니다.');
          state = state.copyWith(status: WalletStatus.completed);
          return WalletResult(success: true, walletAddress: wallet['address']);
        }
      }

      // 지갑 이름 설정 단계로 진행
      state = state.copyWith(
        status: WalletStatus.namingWallet,
        previousStatus: state.status,
      );

      // 이름 설정이 필요함을 알리는 결과 반환
      return WalletResult(
        success: true,
        walletAddress: wallet['address'],
        needsNaming: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 생성 및 등록에 실패했습니다: $e',
      );
      return WalletResult(success: false, error: '지갑 생성 및 등록에 실패했습니다: $e');
    }
  }

  /// 지갑 이름 설정 및 등록
  Future<WalletResult> setWalletNameAndRegister(String walletName) async {
    if (walletName.isEmpty) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 이름을 입력해주세요.',
      );
      return WalletResult(success: false, error: '지갑 이름을 입력해주세요.');
    }

    try {
      state = state.copyWith(
        status: WalletStatus.registeringWallet,
        walletName: walletName,
      );

      // 지갑 등록
      final registerWalletUseCase = ref.read(registerWalletUseCaseProvider);
      final registeredWallet = await registerWalletUseCase.execute(
        name: walletName,
        address: state.walletAddress ?? '',
      );

      final walletId = registeredWallet.data.id;

      state = state.copyWith(
        status: WalletStatus.completed,
        walletId: walletId,
      );

      return WalletResult(
        success: true,
        walletId: walletId,
        walletAddress: state.walletAddress,
      );
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 등록에 실패했습니다: $e',
      );
      return WalletResult(success: false, error: '지갑 등록에 실패했습니다: $e');
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

  /// 에러 발생 시 이전 상태로 돌아가기
  void handleErrorRetry() {
    ref.read(walletViewModelProvider.notifier).returnToPreviousState();
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

  /// 새 지갑 생성 처리
  void handleNewWallet() {
    ref.read(walletViewModelProvider.notifier).generateMnemonic();
  }

  /// 니모닉으로 지갑 복구 처리
  void handleWalletRecovery() {
    ref.read(walletViewModelProvider.notifier).reset();
    ref.read(walletViewModelProvider.notifier).startWalletRecovery();
  }

  /// 니모닉으로 지갑 복구 - 결과를 반환하도록 수정
  Future<WalletResult> recoverWallet(String mnemonic) async {
    if (mnemonic.isEmpty) {
      state = state.copyWith(
        status: WalletStatus.error,
        previousStatus: state.status, // Save current status
        error: '니모닉을 입력해주세요.',
      );
      return WalletResult(success: false, error: '니모닉을 입력해주세요.');
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
        return WalletResult(
          success: false,
          error: '유효하지 않은 니모닉입니다. 다시 확인해주세요.',
        );
      }

      // 복구하려는 지갑 정보 미리 확인
      final createWalletFromMnemonicUseCase = ref.read(
        createWalletFromMnemonicUseCaseProvider,
      );
      final wallet = await createWalletFromMnemonicUseCase.execute(
        mnemonic,
        accountIndex: state.accountIndex,
      );

      // 사용자의 지갑 목록에서 중복 확인
      final authState = ref.read(authViewModelProvider);
      final userWallets = authState.user?.wallets;

      // 중복 지갑 확인
      if (userWallets != null && userWallets.isNotEmpty) {
        final isDuplicate = userWallets.any(
          (existingWallet) =>
              existingWallet.address.toLowerCase() ==
                  wallet['address']?.toLowerCase() ||
              existingWallet.name.toLowerCase() == wallet['did']?.toLowerCase(),
        );

        if (isDuplicate) {
          // 이미 등록된 지갑이 있으면 등록 과정 건너뛰기
          print('이미 등록된 지갑입니다. 서버 등록 과정을 건너뜁니다.');
          state = state.copyWith(status: WalletStatus.completed);
          return WalletResult(success: true, walletAddress: wallet['address']);
        }
      }

      // 지갑 이름 설정 단계로 진행
      state = state.copyWith(
        status: WalletStatus.namingWallet,
        previousStatus: state.status,
        walletAddress: wallet['address'], // 지갑 주소 정보 유지
        publicKey: wallet['publicKey'], // 공개키 정보 유지
        did: wallet['did'], // DID 정보 유지
      );

      // 이름 설정이 필요함을 알리는 결과 반환
      return WalletResult(
        success: true,
        walletAddress: wallet['address'],
        needsNaming: true,
      );

      // 아래 코드는 실행되지 않는 불필요한 코드
      // return await createAndRegisterWallet(mnemonic);
    } catch (e) {
      state = state.copyWith(
        status: WalletStatus.error,
        error: '지갑 복구에 실패했습니다: $e',
      );
      return WalletResult(success: false, error: '지갑 복구에 실패했습니다: $e');
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
final walletViewModelProvider =
    StateNotifierProvider<WalletViewModel, WalletState>((ref) {
      return WalletViewModel(ref);
    });

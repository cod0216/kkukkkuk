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

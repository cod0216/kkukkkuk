abstract class MnemonicRepositoryInterface {
  /// 니모닉을 안전하게 저장
  Future<void> saveMnemonic(String mnemonic);

  /// 저장된 니모닉 가져오기
  Future<String?> getSavedMnemonic();
}

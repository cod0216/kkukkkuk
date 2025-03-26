import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';

/// 인증 관련 작업을 처리하는 컨트롤러
class AuthController {
  final Ref ref;

  AuthController(this.ref);

  /// 인증 초기화
  Future<void> initializeAuth() async {
    ref.read(authCoordinatorProvider.notifier).reset();
  }

  /// 로그인 처리
  Future<void> handleLogin() async {
    try {
      await ref.read(loginProvider.notifier).signInWithKakao();
    } catch (e) {
      print('Login error in controller: $e');
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void handleNewWallet() {
    ref.read(mnemonicWalletProvider.notifier).generateMnemonic();
  }

  // TODO: Implement this method when adding wallet recovery
  void handleWalletRecovery() {
    // Will be implemented with wallet recovery feature
  }

  /// 니모닉 지갑 생성 처리
  void handleMnemonicGeneration() {
    ref.read(mnemonicWalletProvider.notifier).generateMnemonic();
  }

  /// 니모닉 확인 처리
  Future<void> confirmMnemonic() async {
    await ref.read(mnemonicWalletProvider.notifier).confirmMnemonic();
  }

  /// 인증 흐름 초기화
  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(mnemonicWalletProvider.notifier).reset();
    ref.read(authCoordinatorProvider.notifier).reset();
  }
}

/// 인증 컨트롤러 프로바이더
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

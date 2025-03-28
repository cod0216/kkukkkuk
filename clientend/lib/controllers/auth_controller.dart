import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';
import 'package:kkuk_kkuk/providers/network/network_connection_provider.dart';

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

  /// 지갑 복구 화면으로 이동
  void handleWalletRecovery() {
    ref.read(mnemonicWalletProvider.notifier).reset();
    ref.read(mnemonicWalletProvider.notifier).startWalletRecovery();
  }

  /// 니모닉으로 지갑 복구 처리
  Future<void> recoverWallet(String mnemonic) async {
    await ref.read(mnemonicWalletProvider.notifier).recoverWallet(mnemonic);
  }

  /// 니모닉 지갑 생성 처리
  void handleMnemonicGeneration() {
    ref.read(mnemonicWalletProvider.notifier).generateMnemonic();
  }

  /// 니모닉 확인 처리
  Future<void> confirmMnemonic() async {
    await ref.read(mnemonicWalletProvider.notifier).confirmMnemonic();
  }

  /// 네트워크 연결 완료 처리
  void completeNetworkConnection() {
    ref.read(authCoordinatorProvider.notifier).completeAuth();
  }

  /// 인증 흐름 초기화
  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(mnemonicWalletProvider.notifier).reset();
    ref.read(networkConnectionProvider.notifier).reset();
    ref.read(authCoordinatorProvider.notifier).reset();
  }

  /// 에러 발생 시 이전 상태로 돌아가기
  void handleErrorRetry() {
    ref.read(mnemonicWalletProvider.notifier).returnToPreviousState();
  }
}

/// 인증 컨트롤러 프로바이더
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

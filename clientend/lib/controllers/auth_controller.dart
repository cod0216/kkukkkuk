import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/wallet/wallet_provider.dart';
import 'package:kkuk_kkuk/providers/network/network_connection_provider.dart';

/// 인증 단계
enum AuthStep {
  login, // 로그인 단계
  walletSetup, // 지갑 설정 단계
  networkConnection, // 네트워크 연결 단계
  completed, // 인증 완료
  error, // 오류 발생
}

/// 인증 관련 작업을 처리하는 컨트롤러
class AuthController extends StateNotifier<AuthStep> {
  final Ref ref;

  AuthController(this.ref) : super(AuthStep.login);

  /// 인증 초기화
  void initializeAuth() {
    state = AuthStep.login;
  }

  /// 로그인 처리
  Future<void> handleLogin() async {
    try {
      final result = await ref.read(loginProvider.notifier).signInWithKakao();

      if (!result.success) {
        state = AuthStep.error;
        return;
      }

      if (result.hasWallet) {
        moveToNetworkConnection();
      } else {
        ref.read(walletProvider.notifier).reset();
        moveToWalletSetup();
      }
    } catch (e) {
      state = AuthStep.error;
    }
  }

  /// 새 지갑 생성 처리
  void handleNewWallet() {
    ref.read(walletProvider.notifier).generateMnemonic();
  }

  /// 지갑 복구 화면으로 이동
  void handleWalletRecovery() {
    ref.read(walletProvider.notifier).reset();
    ref.read(walletProvider.notifier).startWalletRecovery();
  }

  /// 니모닉으로 지갑 복구 처리
  Future<void> recoverWallet(String mnemonic) async {
    final result = await ref
        .read(walletProvider.notifier)
        .recoverWallet(mnemonic);

    if (result.success) {
      moveToNetworkConnection();
    }
    // 실패 시 WalletProvider에서 이미 에러 상태로 변경됨
  }

  /// 니모닉 지갑 생성 처리
  void handleMnemonicGeneration() {
    ref.read(walletProvider.notifier).generateMnemonic();
  }

  /// 니모닉 확인 처리
  Future<void> confirmMnemonic() async {
    final result = await ref.read(walletProvider.notifier).confirmMnemonic();

    if (result.success) {
      moveToNetworkConnection();
    }
    // 실패 시 WalletProvider에서 이미 에러 상태로 변경됨
  }

  /// 지갑 설정 화면으로 이동
  void moveToWalletSetup() {
    state = AuthStep.walletSetup;
  }

  /// 네트워크 연결 단계로 이동
  void moveToNetworkConnection() {
    state = AuthStep.networkConnection;
  }

  /// 인증 완료 처리
  void completeAuth() {
    state = AuthStep.completed;
  }

  /// 인증 흐름 초기화
  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(walletProvider.notifier).reset();
    ref.read(networkConnectionProvider.notifier).reset();
    state = AuthStep.login;
  }

  /// 에러 발생 시 이전 상태로 돌아가기
  void handleErrorRetry() {
    ref.read(walletProvider.notifier).returnToPreviousState();
  }
}

/// 인증 컨트롤러 프로바이더
final authControllerProvider = StateNotifierProvider<AuthController, AuthStep>((
  ref,
) {
  return AuthController(ref);
});

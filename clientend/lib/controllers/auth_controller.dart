import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';

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
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  /// 지갑 생성 처리
  Future<void> handleWalletCreation() async {
    try {
      await ref.read(walletProvider.notifier).createWallet();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  /// PIN 입력 처리
  void handlePinDigit(String digit) {
    try {
      ref.read(walletProvider.notifier).addPinDigit(digit);
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  /// PIN 삭제 처리
  void handlePinDelete() {
    try {
      ref.read(walletProvider.notifier).deletePinDigit();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  /// 인증 흐름 초기화
  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(walletProvider.notifier).reset();
    ref.read(authCoordinatorProvider.notifier).reset();
  }
}

/// 인증 컨트롤러 프로바이더
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<void> initializeAuth() async {
    ref.read(authCoordinatorProvider.notifier).moveToLogin();
  }

  Future<void> handleLogin() async {
    try {
      await ref.read(loginProvider.notifier).signInWithKakao();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  Future<void> handleWalletCreation() async {
    try {
      await ref.read(walletProvider.notifier).createWallet();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  // PIN flow
  void handlePinDigit(String digit) {
    try {
      ref.read(walletProvider.notifier).addPinDigit(digit);
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void handlePinDelete() {
    try {
      ref.read(walletProvider.notifier).deletePinDigit();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(walletProvider.notifier).reset();
    ref.read(authCoordinatorProvider.notifier).reset();
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

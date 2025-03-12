import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/auth/auth_coordinator.dart';
import 'package:kkuk_kkuk/providers/auth/login_provider.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';
import 'package:kkuk_kkuk/providers/auth/pin_provider.dart';

class AuthController {
  final Ref ref; // Change WidgetRef to StateNotifierProviderRef

  AuthController(this.ref);

  // Login flow
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

  // Wallet flow
  Future<void> handleWalletCreation() async {
    try {
      await ref.read(walletProvider.notifier).createWallet();
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  // PIN flow
  Future<void> handlePinSetup(String pin) async {
    try {
      final pinNotifier = ref.read(pinProvider.notifier);
      pinNotifier.addDigit(pin);
      // The completion will be handled by the PinNotifier when validation is successful
    } catch (e) {
      ref.read(authCoordinatorProvider.notifier).handleError();
    }
  }

  void resetAuthFlow() {
    ref.read(loginProvider.notifier).reset();
    ref.read(walletProvider.notifier).reset();
    ref.read(pinProvider.notifier).reset();
    ref.read(authCoordinatorProvider.notifier).reset();
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref); // Pass ref directly without type casting
});

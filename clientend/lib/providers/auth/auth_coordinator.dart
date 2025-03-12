import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStep { initial, login, creatingWallet, settingPin, completed, error }

class AuthCoordinator extends StateNotifier<AuthStep> {
  final Ref ref;

  AuthCoordinator(this.ref) : super(AuthStep.initial);

  void moveToLogin() {
    state = AuthStep.login;
  }

  void moveToWalletCreation() {
    state = AuthStep.creatingWallet;
  }

  void moveToPinSetup() {
    state = AuthStep.settingPin;
  }

  void completeAuth() {
    state = AuthStep.completed;
  }

  void handleError() {
    state = AuthStep.error;
  }

  void reset() {
    state = AuthStep.initial;
  }
}

final authCoordinatorProvider = StateNotifierProvider<AuthCoordinator, AuthStep>((ref) {
  return AuthCoordinator(ref);
});

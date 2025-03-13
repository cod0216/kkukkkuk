import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStep { initial, login, walletSetup, completed, error }

class AuthCoordinator extends StateNotifier<AuthStep> {
  final Ref ref;

  AuthCoordinator(this.ref) : super(AuthStep.initial);

  void moveToLogin() {
    state = AuthStep.login;
  }

  void moveToWalletSetup() {
    state = AuthStep.walletSetup;
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

final authCoordinatorProvider =
    StateNotifierProvider<AuthCoordinator, AuthStep>((ref) {
      return AuthCoordinator(ref);
    });

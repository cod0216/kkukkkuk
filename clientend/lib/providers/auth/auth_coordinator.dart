import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증 단계
enum AuthStep {
  login, // 로그인 단계
  walletSetup, // 지갑 설정 단계
  completed, // 인증 완료
  error, // 오류 발생
}

/// 인증 흐름을 조정하는 코디네이터
/// 각 인증 단계 간의 전환을 관리합니다.
class AuthCoordinator extends StateNotifier<AuthStep> {
  final Ref ref;

  AuthCoordinator(this.ref) : super(AuthStep.login);

  /// 지갑 설정 화면으로 이동
  void moveToWalletSetup() {
    state = AuthStep.walletSetup;
  }

  /// 인증 완료 처리
  void completeAuth() {
    state = AuthStep.completed;
  }

  /// 오류 상태로 전환
  void handleError() {
    state = AuthStep.error;
  }

  /// 상태 초기화
  void reset() {
    state = AuthStep.login;
  }
}

final authCoordinatorProvider =
    StateNotifierProvider<AuthCoordinator, AuthStep>((ref) {
      return AuthCoordinator(ref);
    });

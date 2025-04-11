import 'package:kkuk_kkuk/entities/user/user.dart';

/// 인증 단계
enum AuthStep {
  login, // 로그인 단계
  walletSetup, // 지갑 생성 안내
  walletCreation, // 실제 지갑 생성 화면
  networkConnection, // 네트워크 연결 단계
  completed, // 인증 완료
  error, // 오류 발생
}

/// 인증 상태를 관리하는 클래스
class AuthState {
  final bool isLoginLoading;
  final String? loginError;
  final AuthStep currentStep;
  final User? user;

  AuthState({
    this.isLoginLoading = false,
    this.loginError,
    this.currentStep = AuthStep.login,
    this.user,
  });

  AuthState copyWith({
    bool? isLoginLoading,
    String? loginError,
    AuthStep? currentStep,
    User? user,
  }) {
    return AuthState(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      loginError: loginError ?? this.loginError,
      currentStep: currentStep ?? this.currentStep,
      user: user ?? this.user,
    );
  }
}

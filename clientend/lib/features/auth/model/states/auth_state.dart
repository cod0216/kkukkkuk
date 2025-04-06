import 'package:kkuk_kkuk/entities/user/user.dart';

/// 인증 단계
enum AuthStep {
  login,        // 로그인 단계
  walletSetup,  // 지갑 생성 안내
  walletCreation, // 실제 지갑 생성 화면
  networkConnection, // 네트워크 연결 단계
  completed,    // 인증 완료
  error,        // 오류 발생
}

/// 네트워크 연결 상태
enum NetworkConnectionStatus {
  initial,    // 초기 상태
  connecting, // 연결 중
  connected,  // 연결됨
  failed,     // 연결 실패
}

/// 인증 상태를 관리하는 클래스
class AuthState {
  final bool isLoginLoading;
  final String? loginError;
  final NetworkConnectionStatus networkStatus;
  final String? networkError;
  final AuthStep currentStep;
  final User? user;

  AuthState({
    this.isLoginLoading = false,
    this.loginError,
    this.networkStatus = NetworkConnectionStatus.initial,
    this.networkError,
    this.currentStep = AuthStep.login,
    this.user,
  });

  AuthState copyWith({
    bool? isLoginLoading,
    String? loginError,
    NetworkConnectionStatus? networkStatus,
    String? networkError,
    AuthStep? currentStep,
    User? user,
  }) {
    return AuthState(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      loginError: loginError ?? this.loginError,
      networkStatus: networkStatus ?? this.networkStatus,
      networkError: networkError ?? this.networkError,
      currentStep: currentStep ?? this.currentStep,
      user: user ?? this.user,
    );
  }
}
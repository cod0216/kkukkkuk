import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/oauth/oauth_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/connection/blockchain_connection_usecase_providers.dart';
import 'package:kkuk_kkuk/viewmodels/wallet_view_model.dart';

/// 인증 단계
enum AuthStep {
  login, // 로그인 단계
  walletSetup, // 지갑 생성 안내
  walletCreation, // 실제 지갑 생성 화면
  networkConnection, // 네트워크 연결 단계
  completed, // 인증 완료
  error, // 오류 발생
}

/// 네트워크 연결 상태
enum NetworkConnectionStatus {
  initial, // 초기 상태
  connecting, // 연결 중
  connected, // 연결됨
  failed, // 연결 실패
}

/// 인증 상태를 관리하는 클래스
class AuthState {
  // 로그인 관련 상태
  final bool isLoginLoading;
  final String? loginError;

  // 네트워크 연결 관련 상태
  final NetworkConnectionStatus networkStatus;
  final String? networkError;

  // 인증 흐름 상태
  final AuthStep currentStep;

  // 사용자 정보
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

/// 로그인 결과를 담는 클래스
class AuthResult {
  final bool success;
  final bool hasWallet;
  final String? error;

  AuthResult({required this.success, this.hasWallet = false, this.error});
}

/// 인증 관련 비즈니스 로직을 처리하는 뷰 모델
class AuthViewModel extends StateNotifier<AuthState> {
  final Ref ref;
  final _secureStorage = const FlutterSecureStorage();
  static const String _privateKeyKey = 'eth_private_key';

  AuthViewModel(this.ref) : super(AuthState());

  /// 인증 초기화
  void initializeAuth() {
    state = state.copyWith(currentStep: AuthStep.login);
  }

  /// 로그인 처리
  Future<AuthResult> signInWithKakao() async {
    try {
      state = state.copyWith(isLoginLoading: true, loginError: null);
      // 카카오 로그인
      final kakaoLoginUseCase = ref.read(kakaoLoginUseCaseProvider);
      final userInfo = await kakaoLoginUseCase.execute();
      // 카카오 로그인 성공 시 로그인 처리
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase.execute(userInfo);

      // 사용자 정보 저장
      state = state.copyWith(isLoginLoading: false, user: user);

      // 로컬 스토리지에 개인키 저장 확인
      // TODO: UseCase로 변경
      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final hasWallet = privateKey != null && privateKey.isNotEmpty;

      return AuthResult(success: true, hasWallet: hasWallet);
    } catch (e) {
      state = state.copyWith(isLoginLoading: false, loginError: '로그인 실패: $e');
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// 블록체인 네트워크 연결
  Future<bool> connectToNetwork() async {
    state = state.copyWith(
      networkStatus: NetworkConnectionStatus.connecting,
      networkError: null,
    );

    try {
      final checkConnectionUseCase = ref.read(
        checkBlockchainConnectionUseCaseProvider,
      );
      final isConnected = await checkConnectionUseCase.execute();

      if (isConnected) {
        state = state.copyWith(
          networkStatus: NetworkConnectionStatus.connected,
        );
        print('블록체인 네트워크에 연결되었습니다.');
        return true;
      } else {
        state = state.copyWith(
          networkStatus: NetworkConnectionStatus.failed,
          networkError: '블록체인 네트워크 연결에 실패했습니다.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        networkStatus: NetworkConnectionStatus.failed,
        networkError: '블록체인 네트워크 연결 중 오류가 발생했습니다: $e',
      );
      return false;
    }
  }

  /// 로그인 처리 핸들러
  Future<void> handleLogin() async {
    try {
      final result = await signInWithKakao();

      if (!result.success) {
        state = state.copyWith(currentStep: AuthStep.error);
        return;
      }

      if (result.hasWallet) {
        moveToNetworkConnection();
      } else {
        ref.read(walletViewModelProvider.notifier).reset();
        moveToWalletSetup();
      }
    } catch (e) {
      state = state.copyWith(currentStep: AuthStep.error);
    }
  }

  /// 지갑 설정 화면으로 이동
  void moveToWalletSetup() {
    state = state.copyWith(currentStep: AuthStep.walletSetup);
  }

  /// 지갑 생성 화면으로 이동
  void moveToWalletCreation(BuildContext context) {
    ref.read(walletViewModelProvider.notifier).reset();

    // Update state before navigation
    state = state.copyWith(currentStep: AuthStep.walletCreation);

    context.push('/wallet-creation', extra: walletViewModelProvider);
  }

  /// 네트워크 연결 단계로 이동
  void moveToNetworkConnection() {
    state = state.copyWith(currentStep: AuthStep.networkConnection);
  }

  /// 인증 완료 처리
  void completeAuth() {
    state = state.copyWith(currentStep: AuthStep.completed);
  }

  /// 에러 발생 시 이전 상태로 돌아가기
  void handleErrorRetry() {
    ref.read(walletViewModelProvider.notifier).returnToPreviousState();
  }

  /// 인증 흐름 초기화
  void reset() {
    ref.read(walletViewModelProvider.notifier).reset();
    state = AuthState();
  }
}

/// 인증 뷰 모델 프로바이더
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ref);
});

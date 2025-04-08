import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/splash/notifiers/auth_notifier.dart'; // AuthNotifier import 추가
import 'package:kkuk_kkuk/pages/splash/notifiers/splash_notifier.dart';
import 'package:kkuk_kkuk/pages/splash/states/splash_status.dart';
import 'package:kkuk_kkuk/pages/wallet/wallet_screen.dart';
import 'package:kkuk_kkuk/widgets/common/logo/animated_logo.dart';
import 'package:kkuk_kkuk/pages/splash/widgets/status_indicator.dart';
// import 'package:kkuk_kkuk/pages/splash/widgets/start_button.dart'; // 기존 StartButton import 제거
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart'; // WalletNotifier import 추가

// Logo related constants (기존 유지)
const logoColor = Color.fromARGB(255, 30, 64, 175);
const pawIconSize = 80.0;
const logoFontSize = 38.0;
const logoSpacing = 32.0;
const singleKukkWidth = logoFontSize * 1.3;

// Animation durations (기존 유지)
const logoDuration = Duration(milliseconds: 1000);
const buttonFadeDuration = Duration(milliseconds: 400);
const initialDelay = Duration(milliseconds: 500);

// Button styling (기존 유지)
const buttonColor = Color(0xFFFEE500);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers (기존 유지)
  late AnimationController _logoAnimationController;
  late Animation<double> _pawAnimation;
  late Animation<double> _textAnimation;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonFadeAnimation;

  bool _isAnimationComplete = false;
  bool _showButton = false;
  bool _isLoginProcessing = false; // 로그인 처리 중 상태 추가

  @override
  void initState() {
    super.initState();

    // Logo Animation Controller (기존 유지)
    _logoAnimationController = AnimationController(
      duration: logoDuration,
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationComplete = true;
        });
        _checkAndShowButton();
      }
    });

    final curvedAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _pawAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // Button Animation Controller (기존 유지)
    _buttonAnimationController = AnimationController(
      duration: buttonFadeDuration,
      vsync: this,
    );
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeIn),
    );

    // Initialize App Connection (기존 유지)
    _initializeApp();

    // Start logo animation after delay (기존 유지)
    Future.delayed(initialDelay, () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
  }

  // Initialize App (기존 유지)
  Future<void> _initializeApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashNotifierProvider.notifier).initializeAppAndConnect();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  // Show Button Check (기존 유지)
  void _checkAndShowButton() {
    final splashState = ref.read(splashNotifierProvider);
    if (_isAnimationComplete && splashState.status == SplashStatus.connected) {
      if (!_showButton) {
        setState(() {
          _showButton = true;
        });
        _buttonAnimationController.forward();
      }
    }
  }

  // --- 로그인 및 화면 전환 로직 ---
  Future<void> _handleStartButtonPressed() async {
    // 이미 로그인 처리 중이면 중복 실행 방지
    if (_isLoginProcessing) return;

    setState(() {
      _isLoginProcessing = true; // 로그인 처리 시작
    });

    final authNotifier = ref.read(authNotifierProvider.notifier);

    try {
      // 1. 카카오 로그인 및 서버 인증 시도
      final authResult = await authNotifier.handleLogin();

      if (!mounted) return; // 위젯 unmount 시 중단

      if (authResult.success) {
        if (authResult.hasWallet) {
          // 2-1. 지갑 있으면 홈으로 이동
          context.go('/home');
        } else {
          // 2-2. 지갑 없으면 WalletScreen 열기
          // Navigator.push 를 사용하여 결과를 받을 수 있도록 함
          final walletCreated = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder:
                  (context) => WalletScreen(viewModel: walletNotifierProvider),
            ),
          );

          if (!mounted) return; // 위젯 unmount 시 중단

          // WalletScreen에서 pop으로 true를 반환하면 (지갑 생성/복구 성공) 홈으로 이동
          if (walletCreated == true) {
            context.go('/home');
          } else {
            // 지갑 생성을 취소하거나 실패한 경우 (예: 뒤로가기)
            // 여기서는 특별한 처리 없이 스플래시 화면에 머무르도록 함
            // 또는 에러 메시지 표시 등 필요에 따라 처리
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('지갑 설정이 완료되지 않았습니다.')));
            setState(() {
              _isLoginProcessing = false; // 로그인 처리 종료
            });
          }
        }
      } else {
        // 3. 로그인 실패 시 에러 메시지 표시
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인에 실패했습니다.')));
        setState(() {
          _isLoginProcessing = false; // 로그인 처리 종료
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류 발생: ${e.toString()}')));
        setState(() {
          _isLoginProcessing = false; // 로그인 처리 종료
        });
      }
    }
  }
  // --- ---

  @override
  Widget build(BuildContext context) {
    // Listen for connection status changes (기존 유지)
    ref.listen<SplashState>(splashNotifierProvider, (previous, next) {
      if (next.status == SplashStatus.connected) {
        _checkAndShowButton();
      }
      if ((next.status == SplashStatus.failed ||
              next.status == SplashStatus.connecting ||
              next.status == SplashStatus.initializing) &&
          _showButton) {
        setState(() {
          _showButton = false;
        });
        _buttonAnimationController.reset();
      }
    });

    final splashState = ref.watch(splashNotifierProvider);
    final bool isConnected = splashState.status == SplashStatus.connected;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Logo (기존 유지)
          AnimatedLogo(
            logoAnimationController: _logoAnimationController,
            pawAnimation: _pawAnimation,
            textAnimation: _textAnimation,
          ),

          // Status Indicator (기존 유지)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child:
                splashState.status == SplashStatus.failed
                    ? StatusIndicator(state: splashState)
                    : const SizedBox.shrink(),
          ),

          // Start Button (수정됨: KakaoLoginButton 스타일 적용 및 로직 연결)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: _buttonFadeAnimation,
              child: IgnorePointer(
                ignoring:
                    !(_showButton &&
                        isConnected &&
                        !_isLoginProcessing), // 로그인 중 비활성화
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // 카카오 버튼 색상
                    foregroundColor: Colors.black87, // 카카오 버튼 텍스트 색상
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ).copyWith(
                    // 비활성화 상태 스타일
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey[300]; // 비활성화 시 회색
                      }
                      return buttonColor;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey[600]; // 비활성화 시 텍스트 색상
                      }
                      return Colors.black87;
                    }),
                  ),
                  // 버튼 클릭 시 _handleStartButtonPressed 호출
                  onPressed:
                      (_showButton && isConnected && !_isLoginProcessing)
                          ? _handleStartButtonPressed
                          : null,
                  child:
                      _isLoginProcessing
                          ? const SizedBox(
                            // 로딩 인디케이터 표시
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black87,
                              ),
                            ),
                          )
                          : const Row(
                            // 카카오 로그인 버튼 UI
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // TODO: 실제 카카오 로고 아이콘 추가
                              Icon(
                                Icons.chat_bubble,
                                color: Colors.black87,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '카카오로 시작하기',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

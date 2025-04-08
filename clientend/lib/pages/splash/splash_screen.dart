import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/splash/notifiers/splash_notifier.dart';
import 'package:kkuk_kkuk/pages/splash/states/splash_status.dart';

const logoColor = Color.fromARGB(255, 30, 64, 175);
const pawIconSize = 80.0;
const logoFontSize = 38.0;
const logoSpacing = 32.0;
const singleKukkWidth = logoFontSize * 1.3;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _pawAnimation;
  late Animation<double> _textAnimation;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonFadeAnimation;

  bool _isAnimationComplete = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeIn),
    );

    _initializeApp();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashState>(splashNotifierProvider, (previous, next) {
      _checkAndShowButton();
      if (next.status == SplashStatus.failed && _showButton) {
        setState(() {
          _showButton = false;
        });
        _buttonAnimationController.reset();
      }
      if ((next.status == SplashStatus.connecting ||
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
          // --- AnimatedBuilder 로고 ---
          Center(
            child: AnimatedBuilder(
              animation: _logoAnimationController,
              builder: (context, child) {
                // 화면 너비의 절반
                final halfScreenWidth = MediaQuery.of(context).size.width / 2;

                // *** 간격 조절 핵심 파트 ***
                // Paw 아이콘 최종 X 위치: 중앙에서 더 왼쪽으로 이동
                final double pawTargetX =
                    -(singleKukkWidth / 2 + logoSpacing / 2) -
                    15.0; // Added extra 15.0 to move more left
                // Text 아이콘 최종 X 위치: 중앙에서 (아이콘 너비의 절반 + 간격의 절반) 만큼 오른쪽으로 이동
                final double textTargetX = (pawIconSize / 2 + logoSpacing / 2);

                // 현재 Paw X 위치: 초기 중앙(0)에서 pawTargetX까지 이동
                final double currentPawX = pawTargetX * _pawAnimation.value;

                // 현재 Text X 위치:
                // 시작: 오른쪽 화면 밖 (대략 halfScreenWidth)
                // 끝: textTargetX
                // 애니메이션 진행률(_textAnimation.value)에 따라 시작 위치에서 끝 위치로 이동
                final double textStartX = halfScreenWidth; // 오른쪽 화면 밖에서 시작
                final double currentTextX =
                    textStartX +
                    (textTargetX - textStartX) * _textAnimation.value;

                return Stack(
                  // Row 대신 Stack과 Positioned 사용 고려
                  clipBehavior: Clip.none, // 자식 요소가 벗어나도 보이도록
                  alignment: Alignment.center,
                  children: [
                    // 1. Paw 아이콘 (Transform 사용)
                    Transform.translate(
                      offset: Offset(currentPawX, 0),
                      child: const Icon(
                        Icons.pets,
                        color: logoColor,
                        size: pawIconSize,
                      ),
                    ),

                    // 2. KUKK KUKK 텍스트 (Transform + Opacity)
                    Transform.translate(
                      offset: Offset(currentTextX, 0),
                      child: Opacity(
                        opacity: _textAnimation.value, // Fade-in 효과
                        child: const Text(
                          'KUKK\nKUKK',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: logoFontSize,
                            fontWeight: FontWeight.bold,
                            color: logoColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- 상태 표시기 / 에러 메시지 ---
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: _buildStatusIndicator(splashState),
          ),

          // --- 시작하기 버튼 ---
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: _buttonFadeAnimation,
              child: IgnorePointer(
                ignoring: !_showButton || !isConnected,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey[300];
                      }
                      return const Color(0xFFFEE500);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey[600];
                      }
                      return Colors.black87;
                    }),
                  ),
                  onPressed:
                      isConnected && _showButton
                          ? () => context.go('/auth')
                          : null,
                  child: const Text(
                    '시작하기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(SplashState state) {
    if (state.status == SplashStatus.connecting ||
        state.status == SplashStatus.initializing) {
      return const Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "네트워크 연결 중...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      );
    } else if (state.status == SplashStatus.failed) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            size: 30,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              state.error ?? "네트워크 연결에 실패했습니다. 인터넷 연결을 확인 후 다시 시도해주세요.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed:
                () =>
                    ref.read(splashNotifierProvider.notifier).retryConnection(),
            child: const Text(
              "다시 시도",
              style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(height: 80); // 공간 확보
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/pages/splash/notifiers/splash_notifier.dart';
import 'package:kkuk_kkuk/pages/splash/states/splash_status.dart';
import 'package:kkuk_kkuk/widgets/common/logo/animated_logo.dart';
import 'package:kkuk_kkuk/pages/splash/widgets/status_indicator.dart';
import 'package:kkuk_kkuk/pages/splash/widgets/start_button.dart';

// Logo related constants
const logoColor = Color.fromARGB(255, 30, 64, 175);
const pawIconSize = 80.0;
const logoFontSize = 38.0;
const logoSpacing = 32.0;
const singleKukkWidth = logoFontSize * 1.3;

// Animation durations
const logoDuration = Duration(milliseconds: 1000);
const buttonFadeDuration = Duration(milliseconds: 400);
const initialDelay = Duration(milliseconds: 500);

// Button styling
const buttonColor = Color(0xFFFEE500);

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

    // Start logo animation regardless of connection status
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

    _buttonAnimationController = AnimationController(
      duration: buttonFadeDuration,
      vsync: this,
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeIn),
    );

    // Initialize app connection in parallel with logo animation
    _initializeApp();

    // Start logo animation after a short delay
    Future.delayed(initialDelay, () {
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

  // Only show button when both animation is complete AND connection is successful
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
    // Listen for connection status changes
    ref.listen<SplashState>(splashNotifierProvider, (previous, next) {
      // Check if we should show the button when connection status changes
      if (next.status == SplashStatus.connected) {
        _checkAndShowButton();
      }

      // Hide button if connection fails or is in progress
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
          // Animated Logo - always plays regardless of connection status
          AnimatedLogo(
            logoAnimationController: _logoAnimationController,
            pawAnimation: _pawAnimation,
            textAnimation: _textAnimation,
          ),

          // Status Indicator - only show for error states, not during connection
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child:
                splashState.status == SplashStatus.failed
                    ? StatusIndicator(state: splashState)
                    : const SizedBox.shrink(), // Hide indicator during connection
          ),

          // Start Button - only appears when connection is complete
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: StartButton(
              buttonFadeAnimation: _buttonFadeAnimation,
              showButton: _showButton,
              isConnected: isConnected,
              onPressed: () => context.go('/auth'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/screens/common/widgets/app_logo.dart';
import 'package:kkuk_kkuk/theme/app_colors.dart';

/// 앱 실행 시 처음 표시되는 스플래시 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 생성
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 페이드인 및 스케일 애니메이션 생성
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // 애니메이션 시작
    _controller.forward();

    // TODO: 앱 초기화 작업 추가 (설정 로드, 네트워크 상태 확인 등)
    // TODO: 자동 로그인 확인 로직 구현
    // TODO: 앱 버전 체크 및 업데이트 알림 기능 추가
    // 1.5초 후 로그인 화면으로 이동
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go('/auth');
      }
    });
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // 앱 로고 텍스트
                AppLogo(),
                const SizedBox(height: 20),
                // TODO: 앱 버전 정보 표시 추가
                // TODO: 로딩 상태 텍스트 추가
              ],
            ),
          ),
        ),
      ),
    );
  }
}

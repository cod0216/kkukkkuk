import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/screens/common/widgets/app_logo.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _permissionsChecked = false;

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

    // 권한 확인 및 앱 초기화
    _checkPermissionsAndInitialize();
  }

  /// 권한 확인 및 앱 초기화 함수
  Future<void> _checkPermissionsAndInitialize() async {
    // 카메라 및 갤러리 권한 확인
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;

    // 권한이 없는 경우에만 권한 요청
    if (cameraStatus.isDenied || photosStatus.isDenied) {
      await _requestPermissions();
    } else {
      // 이미 권한이 있는 경우
      setState(() {
        _permissionsChecked = true;
      });
    }

    // TODO: 앱 초기화 작업 추가 (설정 로드, 네트워크 상태 확인 등)
    // TODO: 자동 로그인 확인 로직 구현
    // TODO: 앱 버전 체크 및 업데이트 알림 기능 추가

    // 권한 처리가 완료된 후에만 타이머 시작
    _navigateToLoginAfterDelay();
  }

  /// 지연 후 로그인 화면으로 이동
  void _navigateToLoginAfterDelay() {
    // 1.5초 후 로그인 화면으로 이동
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go('/auth');
      }
    });
  }

  /// 권한 요청 함수
  Future<void> _requestPermissions() async {
    // 카메라 및 갤러리 권한 요청
    final cameraResult = await Permission.camera.request();
    final photosResult = await Permission.photos.request();

    setState(() {
      _permissionsChecked = true;
    });

    // 권한이 거부된 경우(일반 거부 또는 영구 거부) 안내 다이얼로그 표시
    if (cameraResult.isDenied ||
        photosResult.isDenied ||
        cameraResult.isPermanentlyDenied ||
        photosResult.isPermanentlyDenied) {
      if (mounted) {
        // 다이얼로그가 닫힐 때까지 네비게이션 지연
        await _showPermissionDeniedDialog();
      }
    }
  }

  /// 권한 거부 안내 다이얼로그
  Future<void> _showPermissionDeniedDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('권한 필요'),
        content: const Text(
          '꾹꾹 앱은 반려동물 사진 촬영 및 갤러리 접근을 위해 카메라와 사진 권한이 필요합니다. '
          '설정에서 권한을 허용해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('설정으로 이동'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('나중에'),
          ),
        ],
      ),
    );
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
      backgroundColor: Colors.white,
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
                // 권한 상태 표시
                if (_permissionsChecked)
                  const Text('권한 확인 완료', style: TextStyle(color: Colors.green))
                else
                  const Text(
                    '권한 확인 중...',
                    style: TextStyle(color: Colors.grey),
                  ),
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

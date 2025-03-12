import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/providers/auth_provider.dart';
import 'package:kkuk_kkuk/theme/app_colors.dart';
import 'package:kkuk_kkuk/theme/app_text_styles.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleKakaoLogin() async {
    setState(() {
      _isLoading = true;
    });

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.signInWithKakao();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // 로그인 성공 시 지갑 생성 화면으로 이동
        context.go('/wallet-creation');
      } else {
        // 로그인 실패 시 에러 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text('꾹꾹', style: AppTextStyles.headline2),
              const SizedBox(height: 40),
              Text('환영합니다', style: AppTextStyles.headline1),
              const SizedBox(height: 16),
              const Text(
                '카카오 계정으로 로그인하여 서비스를 이용해보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _handleKakaoLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE500), // 카카오 노란색
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          '카카오로 시작하기',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailError = false;
  bool _isPasswordError = false;
  String _emailErrorText = '이메일을 입력해주세요';

  // 이메일 형식 검증을 위한 정규식
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  void _handleLogin() {
    // Reset error states
    setState(() {
      if (_emailController.text.isEmpty) {
        _isEmailError = true;
        _emailErrorText = '이메일을 입력해주세요';
      } else if (!_emailRegExp.hasMatch(_emailController.text)) {
        _isEmailError = true;
        _emailErrorText = '올바른 이메일 형식이 아닙니다';
      } else {
        _isEmailError = false;
      }

      _isPasswordError = _passwordController.text.isEmpty;
    });

    if (!_isEmailError && !_isPasswordError) {
      // TODO: 로그인 기능 구현
    }
  }

  void _handleForgotPassword() {
    // TODO: 비밀번호 찾기 기능 구현
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('꾹꾹'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/signin-signup'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이메일', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: '이메일을 입력하세요',
                controller: _emailController,
                isError: _isEmailError,
                errorText: _emailErrorText,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Text('비밀번호', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: '비밀번호를 입력하세요',
                controller: _passwordController,
                obscureText: true,
                isError: _isPasswordError,
                errorText: '비밀번호를 입력해주세요',
              ),
              const Spacer(),
              CustomButton(text: '로그인', onPressed: _handleLogin),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _handleForgotPassword,
                  child: Text(
                    '비밀번호를 잊으셨나요?',
                    style: textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/providers/pin_provider.dart';
import 'package:kkuk_kkuk/widgets/pin/pin_display.dart';
import 'package:kkuk_kkuk/widgets/pin/pin_keypad.dart';

class PinSetupScreen extends ConsumerWidget {
  const PinSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(pinProvider);

    // PIN 설정 성공 시 홈 화면으로 이동
    if (pinState.setupState == PinSetupState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('꾹꾹', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '꾹꾹',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildMessage(pinState),
                    const SizedBox(height: 40),
                    // PIN 입력 표시
                    PinDisplay(pinLength: pinState.pin.length),
                    const SizedBox(height: 40),
                    Text(
                      _getPinPrompt(pinState),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 숫자 키패드 - 하단에 고정
            PinKeypad(
              onNumberPressed: (digit) {
                ref.read(pinProvider.notifier).addDigit(digit);
              },
              onDeletePressed: () {
                ref.read(pinProvider.notifier).deleteDigit();
              },
              onCancelPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getPinPrompt(PinState state) {
    switch (state.setupState) {
      case PinSetupState.firstEntry:
        return 'PIN을 입력하세요';
      case PinSetupState.confirming:
        return 'PIN을 다시 입력하세요';
      case PinSetupState.error:
        return 'PIN이 동일하지 않습니다';
      default:
        return 'PIN을 입력하세요';
    }
  }

  Widget _buildMessage(PinState state) {
    String message;
    Color textColor = Colors.black;

    switch (state.setupState) {
      case PinSetupState.firstEntry:
        message = '계정의 보안을 위해\n6자리 PIN을 설정합니다.';
      case PinSetupState.confirming:
        message = '환영합니다!\n김싸피님!';
      case PinSetupState.error:
        message = '환영합니다!\n김싸피님!';
        textColor = Colors.black;
      default:
        message = '계정의 보안을 위해\n6자리 PIN을 설정합니다.';
    }

    return Text(
      message,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

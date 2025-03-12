import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/pin_provider.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_app_bar.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_status_indicator.dart';
import 'package:kkuk_kkuk/widgets/auth/pin/pin_display.dart';
import 'package:kkuk_kkuk/widgets/auth/pin/pin_keypad.dart';

class PinSetupView extends ConsumerWidget {
  final AuthController controller;

  const PinSetupView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(pinProvider);

    return Scaffold(
      appBar: const AuthAppBar(title: 'PIN 설정'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pinState.status == PinSetupStatus.firstEntry
                          ? 'PIN을 입력해주세요'
                          : 'PIN을 한번 더 입력해주세요',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    PinDisplay(
                      pinLength:
                          pinState.status == PinSetupStatus.firstEntry
                              ? pinState.firstPin.length
                              : pinState.currentPin.length,
                      maxLength: 6,
                    ),
                    if (pinState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: AuthStatusIndicator(
                          message: pinState.error!,
                          icon: Icons.error_outline,
                          iconColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              PinKeypad(
                onNumberPressed:
                    (digit) => ref.read(pinProvider.notifier).addDigit(digit),
                onDeletePressed:
                    () => ref.read(pinProvider.notifier).deleteDigit(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/auth_container.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/auth_status_indicator.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/pin/pin_display.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/pin/pin_keypad.dart';

class WalletSetupView extends ConsumerStatefulWidget {
  final AuthController controller;

  const WalletSetupView({super.key, required this.controller});

  @override
  ConsumerState<WalletSetupView> createState() => _WalletSetupViewState();
}

class _WalletSetupViewState extends ConsumerState<WalletSetupView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.handleWalletCreation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return _buildContent(walletState, widget.controller);
  }

  Widget _buildContent(WalletState state, AuthController controller) {
    switch (state.status) {
      case WalletStatus.initial:
      case WalletStatus.generating:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: '지갑을 생성중입니다.',
            icon: Icons.account_balance_wallet_outlined,
          ),
        );

      case WalletStatus.generated:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: 'PIN을 설정해주세요.',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          ),
        );

      case WalletStatus.settingPin:
      case WalletStatus.confirmingPin:
        return _buildPinSetup(state, controller);

      case WalletStatus.encrypting:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: '지갑을 암호화하는 중입니다.',
            icon: Icons.enhanced_encryption,
          ),
        );

      case WalletStatus.saving:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: '지갑을 저장하는 중입니다.',
            icon: Icons.save,
          ),
        );

      case WalletStatus.completed:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: '지갑 설정이 완료되었습니다.',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          ),
        );

      case WalletStatus.error:
        return AuthContainer(
          child: AuthStatusIndicator(
            message: state.error ?? '오류가 발생했습니다.',
            icon: Icons.error_outline,
            iconColor: Colors.red,
          ),
        );
    }
  }

  Widget _buildPinSetup(WalletState state, AuthController controller) {
    final isFirstEntry = state.status == WalletStatus.settingPin;
    final pinLength =
        isFirstEntry
            ? state.firstPin?.length ?? 0
            : state.currentPin?.length ?? 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isFirstEntry ? 'PIN을 입력해주세요' : 'PIN을 한번 더 입력해주세요',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  PinDisplay(pinLength: pinLength, maxLength: 6),
                ],
              ),
            ),
            PinKeypad(
              onNumberPressed: controller.handlePinDigit,
              onDeletePressed: controller.handlePinDelete,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

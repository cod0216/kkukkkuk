import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/pin/pin_display.dart';
import 'package:kkuk_kkuk/screens/auth/widgets/pin/pin_keypad.dart';
import 'package:kkuk_kkuk/screens/common/widgets/status_indicator.dart';

/// 지갑 설정 화면
class WalletSetupView extends ConsumerStatefulWidget {
  final AuthController controller;

  const WalletSetupView({super.key, required this.controller});

  @override
  ConsumerState<WalletSetupView> createState() => _WalletSetupViewState();
}

class _WalletSetupViewState extends ConsumerState<WalletSetupView> {
  // TODO: PIN 입력 실패 시 재시도 기능 추가
  // TODO: PIN 입력 제한 시간 구현
  // TODO: 생체 인증 옵션 추가
  // TODO: PIN 입력 시 진동 피드백 추가
  // TODO: PIN 입력 애니메이션 개선

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  /// 지갑 초기화 처리
  void _initializeWallet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.handleWalletCreation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildContent(walletState),
    );
  }

  /// 상태에 따른 화면 컨텐츠 구성
  Widget _buildContent(WalletState state) {
    return switch (state.status) {
      WalletStatus.initial ||
      WalletStatus.generating ||
      WalletStatus.encrypting ||
      WalletStatus.saving => const Center(
        child: StatusIndicator(message: '잠시만 기다려주세요...'),
      ),
      WalletStatus.generated => const Center(
        child: StatusIndicator(
          message: 'PIN을 설정해주세요.',
          icon: Icons.lock_outline,
          iconColor: Colors.blue,
        ),
      ),
      WalletStatus.settingPin ||
      WalletStatus.confirmingPin => _buildPinSetup(state),
      WalletStatus.completed => const Center(
        child: StatusIndicator(message: '설정이 완료되었습니다.'),
      ),
      WalletStatus.error => Center(
        child: StatusIndicator(
          message: '오류가 발생했습니다. 다시 시도해주세요.',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        ),
      ),
    };
  }

  /// PIN 설정 화면 구성
  Widget _buildPinSetup(WalletState state) {
    final isFirstEntry = state.status == WalletStatus.settingPin;
    final pinLength =
        isFirstEntry
            ? state.firstPin?.length ?? 0
            : state.currentPin?.length ?? 0;

    return Column(
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
          onNumberPressed: widget.controller.handlePinDigit,
          onDeletePressed: widget.controller.handlePinDelete,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

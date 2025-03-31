import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/wallet/wallet_provider.dart';
import 'package:kkuk_kkuk/screens/wallet/views/wallet_choice_view.dart';
import 'package:kkuk_kkuk/screens/wallet/views/mnemonic_display_view.dart';
import 'package:kkuk_kkuk/screens/wallet/views/mnemonic_confirmation_view.dart';
import 'package:kkuk_kkuk/screens/wallet/views/wallet_recovery_view.dart';
import 'package:kkuk_kkuk/screens/common/widgets/loading_indicator.dart';
import 'package:kkuk_kkuk/screens/common/error_view.dart';

/// 지갑 설정 화면
class WalletScreen extends ConsumerWidget {
  final AuthController controller;

  const WalletScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);

    // 초기 상태면 니모닉 생성 시작
    if (walletState.status == WalletStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 아무 작업도 하지 않음 - 선택 화면에서 시작
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(walletState.status))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상태에 따라 다른 내용 표시
              _buildCurrentView(context, ref, walletState, controller),

              // 에러 메시지 표시
              if (walletState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    walletState.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 현재 상태에 맞는 뷰 반환
  Widget _buildCurrentView(
    BuildContext context,
    WidgetRef ref,
    WalletState walletState,
    AuthController controller,
  ) {
    switch (walletState.status) {
      case WalletStatus.initial:
      case WalletStatus.walletChoice:
        return WalletChoiceView(controller: controller);

      case WalletStatus.generatingMnemonic:
        return _buildGeneratingView();

      case WalletStatus.mnemonicGenerated:
        return MnemonicDisplayView(
          walletState: walletState,
          controller: controller,
        );

      case WalletStatus.mnemonicConfirmation:
        return MnemonicConfirmationView(
          walletState: walletState,
          controller: controller,
        );

      case WalletStatus.recoveringWallet:
        return WalletRecoveryView(controller: controller);

      case WalletStatus.creatingWallet:
      case WalletStatus.registeringWallet:
        return _buildCreatingWalletView();

      case WalletStatus.error:
        return ErrorView(
          message: walletState.error ?? '지갑 생성 중 오류가 발생했습니다.',
          onRetry: () => controller.handleErrorRetry(),
        );

      case WalletStatus.completed:
        return const Center(child: Text('지갑 설정이 완료되었습니다.'));
    }
  }

  /// 제목 가져오기
  String _getTitle(WalletStatus status) {
    switch (status) {
      case WalletStatus.initial:
      case WalletStatus.walletChoice:
        return '지갑 설정';
      case WalletStatus.generatingMnemonic:
        return '니모닉 단어 생성 중';
      case WalletStatus.mnemonicGenerated:
        return '니모닉 단어 생성 완료';
      case WalletStatus.mnemonicConfirmation:
        return '니모닉 단어 확인';
      case WalletStatus.recoveringWallet:
        return '지갑 복구';
      case WalletStatus.creatingWallet:
      case WalletStatus.registeringWallet:
        return '지갑 생성 중';
      case WalletStatus.error:
        return '오류';
      case WalletStatus.completed:
        return '지갑 설정 완료';
    }
  }

  /// 니모닉 생성 중 화면
  Widget _buildGeneratingView() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingIndicator(),
            SizedBox(height: 16),
            Text('니모닉 단어를 생성하는 중입니다...'),
          ],
        ),
      ),
    );
  }

  /// 지갑 생성 중 화면
  Widget _buildCreatingWalletView() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingIndicator(),
            SizedBox(height: 16),
            Text('지갑을 생성하는 중입니다...'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/auth/notifiers/auth_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_choice_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/mnemonic_display_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/mnemonic_confirmation_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_recovery_view.dart';
import 'package:kkuk_kkuk/pages/wallet/views/wallet_naming_view.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/loading_indicator.dart';
import 'package:kkuk_kkuk/widgets/common/error_view.dart';

/// 지갑 설정 화면
class WalletScreen extends ConsumerWidget {
  final StateNotifierProvider<WalletNotifier, WalletState> viewModel;

  const WalletScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(viewModel);

    // 초기 상태면 니모닉 생성 시작
    if (walletState.status == WalletStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 아무 작업도 하지 않음 - 선택 화면에서 시작
      });
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상태에 따라 다른 내용 표시
              _buildCurrentView(
                context,
                ref,
                walletState,
                ref.read(viewModel.notifier),
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
    WalletNotifier viewModel,
  ) {
    switch (walletState.status) {
      case WalletStatus.initial:
      case WalletStatus.walletChoice:
        return WalletChoiceView();

      case WalletStatus.generatingMnemonic:
        return _buildGeneratingView();

      case WalletStatus.mnemonicGenerated:
        return MnemonicDisplayView(walletState: walletState);

      case WalletStatus.mnemonicConfirmation:
        return MnemonicConfirmationView(walletState: walletState);

      case WalletStatus.recoveringWallet:
        return WalletRecoveryView();

      case WalletStatus.namingWallet:
        return WalletNamingView();

      case WalletStatus.creatingWallet:
      case WalletStatus.registeringWallet:
        return _buildCreatingWalletView();

      case WalletStatus.error:
        return ErrorView(
          message: walletState.error ?? '지갑 생성 중 오류가 발생했습니다.',
          onRetry: () => viewModel.handleErrorRetry(),
        );

      case WalletStatus.completed:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // First update auth state
          ref.read(authNotifierProvider.notifier).completeAuth();
          // Then close the screen
          Navigator.of(context).pop();
        });
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('지갑 설정이 완료되었습니다.'), SizedBox(height: 24)],
          ),
        );
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

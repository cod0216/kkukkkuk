import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/wallet_provider.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_app_bar.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_container.dart';
import 'package:kkuk_kkuk/widgets/auth/common/auth_status_indicator.dart';

class WalletCreationView extends ConsumerStatefulWidget {
  final AuthController controller;

  const WalletCreationView({super.key, required this.controller});

  @override
  ConsumerState<WalletCreationView> createState() => _WalletCreationViewState();
}

class _WalletCreationViewState extends ConsumerState<WalletCreationView> {
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

    return Scaffold(
      appBar: const AuthAppBar(title: '꾹꾹'),
      body: AuthContainer(child: _buildContent(walletState)),
    );
  }

  Widget _buildContent(WalletState state) {
    switch (state.status) {
      case WalletStatus.creating:
        return AuthStatusIndicator(
          message: '지갑을 생성중입니다.',
          icon: Icons.account_balance_wallet_outlined,
        );
      case WalletStatus.created:
        return AuthStatusIndicator(
          message: '지갑 생성이 완료되었습니다.',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        );
      case WalletStatus.error:
        return AuthStatusIndicator(
          message: state.error ?? '오류가 발생했습니다.',
          icon: Icons.error_outline,
          iconColor: Colors.red,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

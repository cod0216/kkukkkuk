import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/viewmodels/wallet_view_model.dart';

class WalletChoiceView extends ConsumerWidget {
  final WalletViewModel controller;

  const WalletChoiceView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '새 지갑을 생성하거나 기존 지갑을 복구할 수 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: () => controller.handleNewWallet(),
            child: const Text('새 지갑 생성'),
          ),
          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: () => controller.handleWalletRecovery(),
            child: const Text('니모닉으로 지갑 복구'),
          ),
        ],
      ),
    );
  }
}

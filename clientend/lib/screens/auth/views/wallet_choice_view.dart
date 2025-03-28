import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';

class WalletChoiceView extends ConsumerWidget {
  final AuthController controller;

  const WalletChoiceView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '지갑 설정',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

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

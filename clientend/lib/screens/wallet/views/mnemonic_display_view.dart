import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/wallet/wallet_provider.dart';

/// 니모닉 표시 화면
class MnemonicDisplayView extends ConsumerWidget {
  final WalletState walletState;
  final AuthController controller;

  const MnemonicDisplayView({
    super.key,
    required this.walletState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '아래 니모닉 단어를 안전한 곳에 저장해주세요.\n이 단어들은 지갑 복구에 필요합니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // 니모닉 단어 표시
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: walletState.mnemonicWords!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}. ${walletState.mnemonicWords![index]}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              ref.read(walletProvider.notifier).startMnemonicConfirmation();
            },
            child: const Text('니모닉 저장 완료'),
          ),
        ],
      ),
    );
  }
}

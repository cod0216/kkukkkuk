import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';

class MnemonicGenerationView extends ConsumerWidget {
  final AuthController controller;

  const MnemonicGenerationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(mnemonicWalletProvider);

    // 초기 상태면 니모닉 생성 시작
    if (walletState.status == MnemonicWalletStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.handleMnemonicGeneration();
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '니모닉 단어 생성',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          if (walletState.status == MnemonicWalletStatus.generatingMnemonic)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('니모닉 단어를 생성하는 중입니다...'),
                  ],
                ),
              ),
            )
          else if (walletState.status ==
                  MnemonicWalletStatus.mnemonicGenerated &&
              walletState.mnemonicWords != null)
            Expanded(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                      // Change this line to use a method that exists in your provider
                      // or that we'll add to your provider
                      ref
                          .read(mnemonicWalletProvider.notifier)
                          .startMnemonicConfirmation();
                    },
                    child: const Text('니모닉 저장 완료'),
                  ),
                ],
              ),
            ),

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
    );
  }
}

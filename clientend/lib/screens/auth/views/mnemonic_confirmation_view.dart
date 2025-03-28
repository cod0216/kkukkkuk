import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';

class MnemonicConfirmationView extends ConsumerWidget {
  final AuthController controller;

  const MnemonicConfirmationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(mnemonicWalletProvider);
    final selectedCount = walletState.selectedWordIndices?.length ?? 0;
    final totalWords = walletState.mnemonicWords?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '니모닉 단어 확인',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Text(
            '니모닉 단어를 순서대로 선택해주세요. ($selectedCount/$totalWords)',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Selected words display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                walletState.selectedWordIndices?.length ?? 0,
                (index) => Chip(
                  label: Text(
                    '${index + 1}. ${walletState.mnemonicWords?[walletState.selectedWordIndices?[index] ?? 0] ?? ""}',
                  ),
                  onDeleted: () {
                    // Remove the last selected word only
                    if (index ==
                        (walletState.selectedWordIndices?.length ?? 0) - 1) {
                      ref
                          .read(mnemonicWalletProvider.notifier)
                          .removeLastSelectedWord();
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Mnemonic word grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: walletState.mnemonicWords?.length ?? 0,
              itemBuilder: (context, index) {
                final isSelected =
                    walletState.selectedWordIndices?.contains(index) ?? false;
                final isNextInSequence =
                    walletState.selectedWordIndices?.length ==
                    walletState.mnemonicWords?.indexOf(
                      walletState.mnemonicWords![index],
                    );

                return GestureDetector(
                  onTap:
                      isSelected
                          ? null
                          : () {
                            ref
                                .read(mnemonicWalletProvider.notifier)
                                .selectMnemonicWord(index);
                          },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          !isSelected && isNextInSequence
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      walletState.mnemonicWords?[index] ?? '',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 확인 버튼
          ElevatedButton(
            onPressed:
                walletState.status != MnemonicWalletStatus.creatingWallet &&
                        walletState.status !=
                            MnemonicWalletStatus.registeringWallet
                    ? () => controller.confirmMnemonic()
                    : null,
            child:
                walletState.status == MnemonicWalletStatus.creatingWallet ||
                        walletState.status ==
                            MnemonicWalletStatus.registeringWallet
                    ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('처리 중...'),
                      ],
                    )
                    : const Text('확인 및 지갑 생성'),
          ),

          // 에러 메시지
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

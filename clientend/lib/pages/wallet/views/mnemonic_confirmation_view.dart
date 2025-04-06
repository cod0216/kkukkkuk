import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/wallet/notifiers/wallet_notifier.dart';

/// 니모닉 확인 화면
class MnemonicConfirmationView extends ConsumerWidget {
  final WalletState walletState;
  const MnemonicConfirmationView({super.key, required this.walletState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = walletState.selectedWordIndices?.length ?? 0;
    final totalWords = walletState.mnemonicWords?.length ?? 0;

    return Expanded(
      child: Column(
        children: [
          Text(
            '니모닉 단어를 순서대로 선택해주세요. ($selectedCount/$totalWords)',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 선택된 단어 표시
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
                    // 마지막 선택된 단어만 삭제 가능
                    if (index ==
                        (walletState.selectedWordIndices?.length ?? 0) - 1) {
                      ref
                          .read(walletNotifierProvider.notifier)
                          .removeLastSelectedWord();
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 니모닉 단어 그리드
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
                                .read(walletNotifierProvider.notifier)
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
                      walletState.mnemonicWords![index],
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
                walletState.status != WalletStatus.creatingWallet &&
                        walletState.status != WalletStatus.registeringWallet
                    ? () =>
                        ref
                            .read(walletNotifierProvider.notifier)
                            .confirmMnemonic()
                    : null,
            child:
                walletState.status == WalletStatus.creatingWallet ||
                        walletState.status == WalletStatus.registeringWallet
                    ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('처리 중...'),
                      ],
                    )
                    : const Text('확인'),
          ),
        ],
      ),
    );
  }
}

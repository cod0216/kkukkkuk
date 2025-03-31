import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';
import 'package:kkuk_kkuk/screens/common/widgets/loading_indicator.dart';

/// 니모닉 생성 및 검증
class MnemonicSetupView extends ConsumerWidget {
  final AuthController controller;

  const MnemonicSetupView({super.key, required this.controller});

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
            _getTitle(walletState.status),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 상태에 따라 다른 내용 표시
          if (walletState.status == MnemonicWalletStatus.generatingMnemonic)
            _buildGeneratingView()
          else if (walletState.status == MnemonicWalletStatus.mnemonicGenerated)
            _buildMnemonicDisplayView(context, ref, walletState)
          else if (walletState.status ==
              MnemonicWalletStatus.mnemonicConfirmation)
            _buildMnemonicConfirmationView(
              context,
              ref,
              walletState,
              controller,
            )
          else if (walletState.status == MnemonicWalletStatus.creatingWallet ||
              walletState.status == MnemonicWalletStatus.registeringWallet)
            _buildCreatingWalletView(),

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

  /// 제목 가져오기
  String _getTitle(MnemonicWalletStatus status) {
    switch (status) {
      case MnemonicWalletStatus.generatingMnemonic:
        return '니모닉 단어 생성 중';
      case MnemonicWalletStatus.mnemonicGenerated:
        return '니모닉 단어 생성 완료';
      case MnemonicWalletStatus.mnemonicConfirmation:
        return '니모닉 단어 확인';
      case MnemonicWalletStatus.creatingWallet:
      case MnemonicWalletStatus.registeringWallet:
        return '지갑 생성 중';
      default:
        return '니모닉 설정';
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

  /// 니모닉 표시 화면
  Widget _buildMnemonicDisplayView(
    BuildContext context,
    WidgetRef ref,
    MnemonicWalletState walletState,
  ) {
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
              ref
                  .read(mnemonicWalletProvider.notifier)
                  .startMnemonicConfirmation();
            },
            child: const Text('니모닉 저장 완료'),
          ),
        ],
      ),
    );
  }

  /// 니모닉 확인 화면
  Widget _buildMnemonicConfirmationView(
    BuildContext context,
    WidgetRef ref,
    MnemonicWalletState walletState,
    AuthController controller,
  ) {
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
                          .read(mnemonicWalletProvider.notifier)
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

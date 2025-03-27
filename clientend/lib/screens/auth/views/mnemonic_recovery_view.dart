import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/auth/mnemonic_wallet_provider.dart';
import 'dart:math' as math;

class MnemonicRecoveryView extends ConsumerStatefulWidget {
  final AuthController controller;

  const MnemonicRecoveryView({super.key, required this.controller});

  @override
  ConsumerState<MnemonicRecoveryView> createState() =>
      _MnemonicRecoveryViewState();
}

class _MnemonicRecoveryViewState extends ConsumerState<MnemonicRecoveryView> {
  final List<TextEditingController> _wordControllers = List.generate(
    12,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(12, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _wordControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // 모든 니모닉 단어를 공백으로 구분된 하나의 문자열로 결합
  String _getMnemonicString() {
    return _wordControllers
        .map((controller) => controller.text.trim())
        .join(' ');
  }

  // 다음 입력 필드로 포커스 이동
  void _moveFocus(int currentIndex) {
    if (currentIndex < 11) {
      _focusNodes[currentIndex + 1].requestFocus();
    } else {
      // 마지막 필드에서는 포커스 해제
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(mnemonicWalletProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '니모닉 복구',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          const Text(
            '기존 니모닉 단어를 입력해주세요. 단어는 순서대로 입력하세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          // 니모닉 입력 그리드
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _wordControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        hintText: '단어 ${index + 1}',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                      ),
                      onSubmitted: (_) => _moveFocus(index),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 복구 버튼
          ElevatedButton(
            onPressed:
                walletState.status != MnemonicWalletStatus.creatingWallet &&
                        walletState.status !=
                            MnemonicWalletStatus.registeringWallet
                    ? () =>
                        widget.controller.recoverWallet(_getMnemonicString())
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
                        Text('복구 중...'),
                      ],
                    )
                    : const Text('지갑 복구하기'),
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

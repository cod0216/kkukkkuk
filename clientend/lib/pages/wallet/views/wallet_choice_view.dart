import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가

class WalletChoiceView extends ConsumerWidget {
  const WalletChoiceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Expanded 제거하고 Column 사용
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼 가로 확장
      children: [
        // 헤더 추가
        const CustomHeader(
          title: '지갑 설정',
          subtitle: '새 지갑을 생성하거나 기존 지갑을 복구할 수 있습니다.',
        ),
        const Spacer(), // 버튼들을 하단 근처로 밀기

        // 새 지갑 생성 버튼 (스타일 적용)
        ElevatedButton.icon(
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: const Text('새 지갑 생성'),
          onPressed: () => ref.read(walletNotifierProvider.notifier).handleNewWallet(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
        ),
        const SizedBox(height: 16), // 버튼 사이 간격

        // 지갑 복구 버튼 (스타일 적용)
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh, size: 20),
          label: const Text('니모닉으로 지갑 복구'),
          onPressed: () => ref.read(walletNotifierProvider.notifier).handleWalletRecovery(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: Colors.grey.shade400, width: 1.0),
          ),
        ),
        const SizedBox(height: 40), // 하단 여백
      ],
    );
  }
}
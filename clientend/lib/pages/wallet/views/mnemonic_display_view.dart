import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard 사용 위해 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가

/// 니모닉 표시 화면
class MnemonicDisplayView extends ConsumerWidget {
  final WalletState walletState;

  const MnemonicDisplayView({super.key, required this.walletState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mnemonicString = walletState.mnemonicWords?.join(' ') ?? '';

    // Expanded 유지
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 헤더 추가
        const CustomHeader(
          title: '니모닉 백업',
          subtitle: '아래 12개의 단어를 순서대로 안전한 곳에 저장해주세요.\n이 단어들은 지갑 복구 시 반드시 필요합니다.',
        ),
        // 니모닉 단어 표시 컨테이너
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // 배경색
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300), // 테두리
          ),
          child: GridView.builder(
            shrinkWrap: true, // Column 안에서 사용하므로 shrinkWrap 필요
            physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 한 줄에 3개
              childAspectRatio: 2.8, // 가로 세로 비율 조정
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: walletState.mnemonicWords?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 각 단어 배경색
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300), // 단어 테두리
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4), // 내부 패딩
                child: Text(
                  '${index + 1}. ${walletState.mnemonicWords![index]}',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), // 폰트 조정
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // 복사 버튼 추가
        TextButton.icon(
          icon: const Icon(Icons.copy, size: 16),
          label: const Text('니모닉 복사하기'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: mnemonicString));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('니모닉이 클립보드에 복사되었습니다.')),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
        ),

        const Spacer(), // 버튼을 하단으로 밀기

        // 저장 완료 버튼 (스타일 적용)
        ElevatedButton(
          onPressed: () {
            ref.read(walletNotifierProvider.notifier).startMnemonicConfirmation();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
          child: const Text('저장 확인 및 다음 단계'), // 버튼 텍스트 변경
        ),
      ],
    );
  }
}
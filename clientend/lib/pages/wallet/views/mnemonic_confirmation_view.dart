import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가

/// 니모닉 확인 화면
class MnemonicConfirmationView extends ConsumerWidget {
  final WalletState walletState;
  const MnemonicConfirmationView({super.key, required this.walletState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = walletState.selectedWordIndices?.length ?? 0;
    final totalWords = walletState.mnemonicWords?.length ?? 0;
    final bool isLoading = walletState.status == WalletStatus.creatingWallet ||
        walletState.status == WalletStatus.registeringWallet; // 로딩 상태

    // Expanded 유지
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 헤더 추가
        CustomHeader(
          title: '니모닉 확인',
          subtitle: '백업한 니모닉 단어를 순서대로 선택해주세요.\n($selectedCount/$totalWords)',
        ),

        // 선택된 단어 표시 컨테이너 (스타일 수정)
        Container(
          height: 120, // 고정 높이 또는 Flexible 사용 고려
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 16), // 상하 마진 추가
          decoration: BoxDecoration(
            color: Colors.white, // 배경 흰색
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300), // 테두리
          ),
          child: selectedCount == 0
              ? Center(child: Text('아래 단어를 순서대로 선택하세요.', style: TextStyle(color: Colors.grey[600])))
              : SingleChildScrollView( // 내용 많을 경우 스크롤
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: List.generate(
                selectedCount,
                    (index) => Chip(
                  label: Text(
                    '${index + 1}. ${walletState.mnemonicWords?[walletState.selectedWordIndices![index]] ?? ""}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  onDeleted: () {
                    // 마지막 선택된 단어만 삭제 가능하게 유지
                    if (index == selectedCount - 1 && !isLoading) {
                      ref.read(walletNotifierProvider.notifier).removeLastSelectedWord();
                    }
                  },
                  deleteIconColor: Colors.grey[600],
                  backgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: Colors.grey.shade300)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),
        ),


        // 니모닉 단어 선택 그리드 (스타일 수정)
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.8, // 비율 조정
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: walletState.mnemonicWords?.length ?? 0, // 섞인 단어 사용
            itemBuilder: (context, index) {
              final word = walletState.mnemonicWords![index];
              // 선택된 원래 인덱스 찾기
              final originalIndex = walletState.mnemonicWords!.indexOf(word);
              final isSelected = walletState.selectedWordIndices?.contains(originalIndex) ?? false;

              return InkWell( // GestureDetector 대신 InkWell 사용
                onTap: isLoading || isSelected
                    ? null // 로딩 중이거나 이미 선택된 단어는 탭 비활성화
                    : () {
                  ref.read(walletNotifierProvider.notifier).selectMnemonicWord(originalIndex);
                },
                borderRadius: BorderRadius.circular(8), // InkWell 효과 범위
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey.shade400 : Colors.white, // 선택 시 회색 처리
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      // 선택된 단어는 취소선 효과 (선택 사항)
                      // decoration: isSelected ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16), // 그리드와 버튼 사이 간격

        // 확인 버튼 (스타일 적용)
        ElevatedButton(
          onPressed: isLoading || selectedCount != totalWords // 로딩 중이거나 단어 선택 완료 안됐으면 비활성화
              ? null
              : () => ref.read(walletNotifierProvider.notifier).confirmMnemonic(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.6), // 비활성 스타일
          ),
          child: isLoading
              ? const SizedBox( // 로딩 인디케이터
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
              : const Text('니모닉 확인'),
        ),
      ],
    );
  }
}

// **참고:** `WalletState`에 `shuffledMnemonicWords` 필드가 필요합니다.
// `startMnemonicConfirmation` 함수에서 단어를 섞어서 저장해야 합니다.
/*
// in WalletState
final List<String>? shuffledMnemonicWords;

// in WalletNotifier
void startMnemonicConfirmation() {
  if (state.status == WalletStatus.mnemonicGenerated && state.mnemonicWords != null) {
    final shuffled = List<String>.from(state.mnemonicWords!)..shuffle(); // 단어 섞기
    state = state.copyWith(
      status: WalletStatus.mnemonicConfirmation,
      previousStatus: state.status,
      selectedWordIndices: [],
      shuffledMnemonicWords: shuffled, // 섞인 단어 저장
      error: null,
    );
  }
}
*/
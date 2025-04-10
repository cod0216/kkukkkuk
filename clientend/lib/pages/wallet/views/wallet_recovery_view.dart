import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가

class WalletRecoveryView extends ConsumerStatefulWidget {
  const WalletRecoveryView({super.key});

  @override
  ConsumerState<WalletRecoveryView> createState() => _WalletRecoveryViewState();
}

class _WalletRecoveryViewState extends ConsumerState<WalletRecoveryView> {
  final List<TextEditingController> _wordControllers = List.generate(
    12, (_) => TextEditingController(),
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

  String _getMnemonicString() {
    return _wordControllers.map((controller) => controller.text.trim().toLowerCase()).join(' '); // 소문자로 변환 추가
  }

  void _moveFocus(int currentIndex) {
    if (currentIndex < 11) {
      _focusNodes[currentIndex + 1].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  // 입력 필드 스타일
  InputDecoration _buildWordInputDecoration(int index) {
    return InputDecoration(
      // counterText 제거 (칸 내부 숫자 표시 안 함)
      counterText: '',
      // border: InputBorder.none, // 테두리 제거
      border: OutlineInputBorder( // 얇은 테두리 추가
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder( // 포커스 시 테두리
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), // 패딩 조정
      hintText: '${index + 1}', // 숫자 힌트만 표시
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white, // 배경색 흰색
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final bool isLoading = walletState.status == WalletStatus.creatingWallet ||
        walletState.status == WalletStatus.registeringWallet; // 로딩 상태

    // Expanded 유지
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 헤더 추가
        const CustomHeader(
          title: '지갑 복구',
          subtitle: '백업한 12개의 니모닉 단어를 순서대로 입력해주세요.',
        ),

        // 니모닉 입력 그리드 (스타일 수정)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12), // 내부 패딩
            margin: const EdgeInsets.symmetric(vertical: 16), // 상하 마진
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // 그리드 배경색
              borderRadius: BorderRadius.circular(12),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개
                childAspectRatio: 2.8, // 비율 조정
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                // 각 입력 필드를 TextField 대신 TextFormField 사용 (유효성 검사 등 활용 가능)
                return TextFormField(
                  controller: _wordControllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  keyboardType: TextInputType.text,
                  // 자동 수정, 제안 비활성화 (니모닉 입력 시 불편할 수 있음)
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: (index == 11) ? TextInputAction.done : TextInputAction.next, // 마지막 필드는 완료
                  maxLength: 15, // 단어 길이 제한 (적절히 조절)
                  decoration: _buildWordInputDecoration(index), // 스타일 적용
                  onChanged: (value) {
                    // 단어 입력 시 자동으로 다음 칸 이동 (선택 사항)
                    if (value.contains(' ') && index < 11) {
                      _wordControllers[index].text = value.replaceAll(' ', ''); // 공백 제거
                      _moveFocus(index);
                    }
                  },
                  onFieldSubmitted: (_) => _moveFocus(index), // 엔터키로 다음 칸 이동
                  validator: (value) { // 간단한 유효성 검사 (선택 사항)
                    if (value == null || value.trim().isEmpty) {
                      return '단어 입력'; // 필드가 비었을 경우
                    }
                    // 추가적인 영문자 검사 등 필요 시 추가
                    return null;
                  },
                );
              },
            ),
          ),
        ),

        // 복구 버튼 (스타일 적용)
        ElevatedButton(
          onPressed: isLoading ? null : () {
            // 복구 전 폼 유효성 검사 (선택 사항)
            // if (_formKey.currentState?.validate() ?? false) { // Form 위젯으로 감싸야 함
            ref.read(walletNotifierProvider.notifier).recoverWallet(_getMnemonicString());
            // }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
          ),
          child: isLoading
              ? const SizedBox( // 로딩 인디케이터
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
              : const Text('지갑 복구하기'),
        ),
      ],
    );
  }
}
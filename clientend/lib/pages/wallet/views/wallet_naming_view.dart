import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가

class WalletNamingView extends ConsumerStatefulWidget {
  const WalletNamingView({super.key});

  @override
  ConsumerState<WalletNamingView> createState() => _WalletNamingViewState();
}

class _WalletNamingViewState extends ConsumerState<WalletNamingView> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // 로딩 상태는 Notifier에서 관리하므로 _isSubmitting 제거 가능
  // bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // 입력 필드 스타일
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      // labelText: '지갑 이름', // PrimarySection에서 처리하므로 제거
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    // Notifier의 로딩 상태 감시
    final isLoading = ref.watch(walletNotifierProvider.select((state) =>
    state.status == WalletStatus.registeringWallet));

    // Expanded 제거하고 Column 사용
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더 추가
          const CustomHeader(
            title: '지갑 이름 설정',
            subtitle: '지갑을 구분하기 쉽도록 이름을 설정해주세요.',
          ),
          const SizedBox(height: 32), // 헤더와 입력 필드 사이 간격

          // 지갑 이름 입력 필드 (스타일 적용)
          TextFormField(
            controller: _nameController,
            decoration: _buildInputDecoration('예: 내 메인 지갑'), // 스타일 적용
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '지갑 이름을 입력해주세요';
              }
              if (value.length > 20) { // 이름 길이 제한 (선택 사항)
                return '이름은 20자 이하로 입력해주세요.';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: isLoading ? null : (_) => _submitWalletName(), // 로딩 중 제출 방지
          ),
          const Spacer(), // 버튼을 하단으로 밀기

          // 완료 버튼 (스타일 적용)
          ElevatedButton(
            onPressed: isLoading ? null : _submitWalletName,
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
                : const Text('완료'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitWalletName() async {
    // 키보드 숨기기
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // Notifier의 로딩 상태를 사용하므로 _isSubmitting 제거
    // setState(() => _isSubmitting = true);

    try {
      // Notifier 함수 호출 (로딩 상태는 Notifier 내부에서 관리)
      await ref
          .read(walletNotifierProvider.notifier)
          .setWalletNameAndRegister(_nameController.text.trim());
      // 성공 시 WalletScreen에서 자동으로 다음 단계로 이동하거나 pop됨
    } catch(e) {
      // 실패 시 에러는 WalletScreen에서 ErrorView로 표시될 수 있음
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('지갑 등록 실패: $e')),
        );
      }
    }
    // finally { // 로딩 상태는 Notifier에서 관리
    //   if (mounted) {
    //     setState(() => _isSubmitting = false);
    //   }
    // }
  }
}
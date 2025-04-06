import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/notifiers/pet_register_notifier.dart';
import 'package:kkuk_kkuk/shared/ui/widgets/status_indicator.dart';
import 'package:kkuk_kkuk/shared/ui/widgets/dual_buttons.dart';

// 반려동물 등록 완료 화면
class PetRegisterCompleteView extends ConsumerWidget {
  const PetRegisterCompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 반려동물 등록 상태 관리
    final petRegisterState = ref.watch(petRegisterNotifierProvider);
    final petName = petRegisterState.pet?.name ?? '반려동물';

    // TODO: 등록 실패 시 에러 처리 및 표시
    // TODO: 등록 성공 시 애니메이션 효과 추가
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 등록 완료 상태 표시
            StatusIndicator(
              message: '[$petName]이(가) 성공적으로\n등록되었습니다.',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              iconSize: 80,
              messageStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // 추가 등록 안내 메시지
            Text(
              '더 등록하고 싶은 반려동물이\n있으신가요?',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // 네비게이션 버튼
            DualButtons(
              onLeft: () => Navigator.of(context).pop(),
              onRight:
                  () => ref.read(petRegisterNotifierProvider.notifier).reset(),
              leftLabel: '아니오',
              rightLabel: '예',
            ),
          ],
        ),
      ),
    );
  }
}

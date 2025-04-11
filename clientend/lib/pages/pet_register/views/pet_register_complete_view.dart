import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // GoRouter import 추가
import 'package:kkuk_kkuk/pages/pet_register/notifiers/pet_register_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/status_indicator.dart';
// import 'package:kkuk_kkuk/widgets/common/dual_buttons.dart'; // 사용 안 함
import 'package:kkuk_kkuk/widgets/mypage/my_setting_item.dart'; // MySettingItem import 추가

// 반려동물 등록 완료 화면
class PetRegisterCompleteView extends ConsumerWidget {
  const PetRegisterCompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petRegisterState = ref.watch(petRegisterNotifierProvider);
    final petName = petRegisterState.pet?.name ?? '반려동물';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 등록 완료 상태 표시 (기존 유지)
            StatusIndicator(
              message: '[$petName]이(가) 성공적으로\n등록되었습니다.',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              iconSize: 80,
              messageStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3, // 줄 간격 조정
              ),
            ),
            const SizedBox(height: 32),

            // 추가 등록 안내 메시지 (기존 유지)
            Text(
              '더 등록하고 싶은 반려동물이\n있으신가요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ), // 색상 약간 진하게
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // --- 네비게이션 버튼 (MySettingItem 사용) ---
            Column(
              mainAxisSize: MainAxisSize.min, // Column 크기 최소화
              children: [
                MySettingItem(
                  icon: Icons.add_circle_outline_rounded, // 아이콘 변경
                  label: '예 (다른 반려동물 등록)',
                  onTap:
                      () =>
                          ref
                              .read(petRegisterNotifierProvider.notifier)
                              .reset(), // 등록 상태 초기화
                  iconColor:
                      Theme.of(context).primaryColor, // 아이콘 색상 지정 (선택 사항)
                ),
                const SizedBox(height: 12), // 버튼 사이 간격
                MySettingItem(
                  icon: Icons.home_outlined, // 아이콘 변경
                  label: '아니오 (홈으로 가기)',
                  onTap: () => context.go('/pets'), // '/pets' 경로로 이동
                  iconColor: Colors.grey.shade700, // 아이콘 색상 지정 (선택 사항)
                ),
              ],
            ),
            // --- 네비게이션 버튼 끝 ---
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/pet_register/notifiers/pet_register_notifier.dart';
import 'package:kkuk_kkuk/pages/pet_register/state/pet_register_state.dart';
import 'package:kkuk_kkuk/pages/pet_register/state/pet_register_step.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_info_view.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_image_view.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_register_complete_view.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';

// 반려동물 등록 화면 위젯
class PetRegisterScreen extends ConsumerStatefulWidget {
  const PetRegisterScreen({super.key});

  @override
  ConsumerState<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends ConsumerState<PetRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // 현재 등록 단계 상태 관리
    final currentStep = ref.watch(petRegisterNotifierProvider).currentStep;

    // 에러 상태 감지 및 표시 (선택 사항)
    ref.listen<PetRegisterState>(petRegisterNotifierProvider, (previous, next) {
      if (previous?.error == null && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildCurrentView(currentStep),
      ),
    );
  }

  // 현재 단계에 따른 화면 반환 (Key 추가 유지)
  Widget _buildCurrentView(PetRegisterStep step) {
    switch (step) {
      case PetRegisterStep.info:
        return PetInfoView(key: const ValueKey('PetInfoView'));
      case PetRegisterStep.image:
        return PetImageView(key: const ValueKey('PetImageView'));
      case PetRegisterStep.completed:
        return const PetRegisterCompleteView(
          key: ValueKey('PetRegisterCompleteView'),
        );
    }
  }
}

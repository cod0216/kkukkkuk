import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/pet_register/notifiers/pet_register_notifier.dart';
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
  void dispose() {
    // 위젯이 dispose되기 전에 직접 reset 호출
    ref.read(petRegisterNotifierProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 현재 등록 단계 상태 관리
    final currentStep = ref.watch(petRegisterNotifierProvider).currentStep;

    return Scaffold(
      appBar: CustomAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentView(currentStep),
      ),
    );
  }

  // 현재 단계에 따른 화면 반환
  Widget _buildCurrentView(PetRegisterStep step) {
    switch (step) {
      case PetRegisterStep.info:
        return PetInfoView(); // 기본 정보 입력 화면
      case PetRegisterStep.image:
        return PetImageView(); // 이미지 등록 화면
      case PetRegisterStep.completed:
        return const PetRegisterCompleteView(); // 등록 완료 화면
    }
  }
}

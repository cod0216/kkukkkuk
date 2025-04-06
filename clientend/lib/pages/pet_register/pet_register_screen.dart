import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_register_provider.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_info_view.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_image_view.dart';
import 'package:kkuk_kkuk/pages/pet_register/views/pet_register_complete_view.dart';

// 반려동물 등록 화면 위젯
class PetRegisterScreen extends ConsumerStatefulWidget {
  const PetRegisterScreen({super.key});

  @override
  ConsumerState<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends ConsumerState<PetRegisterScreen> {
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petRegisterProvider.notifier).reset();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 현재 등록 단계 상태 관리
    final currentStep = ref.watch(petRegisterProvider).currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('반려동물 등록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 시 상태 초기화 후 화면 종료
            ref.read(petRegisterProvider.notifier).reset();
            Navigator.of(context).pop();
          },
        ),
      ),
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

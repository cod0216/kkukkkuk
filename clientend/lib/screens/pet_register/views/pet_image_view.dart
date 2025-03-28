import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/pet_register_controller.dart';
import 'package:kkuk_kkuk/providers/pet/pet_register_provider.dart';
import 'package:kkuk_kkuk/screens/common/widgets/custom_image_placeholder.dart';
import 'package:kkuk_kkuk/screens/common/widgets/image_source_button.dart';
import 'package:kkuk_kkuk/screens/common/widgets/skip_button.dart';
import 'package:kkuk_kkuk/screens/common/widgets/dual_buttons.dart';
import 'package:kkuk_kkuk/screens/common/widgets/custom_header.dart';

// 반려동물 이미지 등록 화면
class PetImageView extends ConsumerStatefulWidget {
  final PetRegisterController controller;

  const PetImageView({super.key, required this.controller});

  @override
  ConsumerState<PetImageView> createState() => _PetImageViewState();
}

class _PetImageViewState extends ConsumerState<PetImageView> {
  // 상태 관리
  bool _isLoading = false;
  bool _hasImage = false; // 이미지 선택 여부 추적

  // 이전 단계로 이동
  void _onPrevious() {
    widget.controller.moveToPreviousStep();
  }

  // 다음 단계로 이동
  void _onNext() {
    if (!_hasImage) {
      _showImageRequiredDialog();
    } else {
      _registerPet();
    }
  }

  // 반려동물 등록 처리
  void _registerPet() {
    // TODO: 이미지 업로드 로직 구현
    widget.controller.registerPet();
  }

  // 이미지 등록 확인 다이얼로그
  void _showImageRequiredDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('이미지 등록'),
            content: const Text('반려동물 이미지를 등록해 주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _skipImageAndRegister();
                },
                child: const Text('건너뛰기'),
              ),
            ],
          ),
    );
  }

  // 이미지 등록 건너뛰기
  void _skipImageAndRegister() {
    // TODO: 기본 이미지 설정 로직 추가
    _registerPet();
  }

  // 카메라로 사진 촬영
  void _takePicture() async {
    // TODO: 카메라 권한 확인 및 처리
    // TODO: 이미지 압축 및 최적화
    // TODO: 실제 카메라 기능 구현
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('사진 촬영 기능은 추후 구현 예정입니다.')));
    setState(() => _hasImage = true);
  }

  // 갤러리에서 이미지 선택
  void _pickFromGallery() async {
    // TODO: 갤러리 권한 확인 및 처리
    // TODO: 이미지 선택 및 크롭 기능 구현
    // TODO: 이미지 압축 및 최적화
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('갤러리에서 선택 기능은 추후 구현 예정입니다.')));
    setState(() => _hasImage = true);
  }

  @override
  Widget build(BuildContext context) {
    final petRegisterState = ref.watch(petRegisterProvider);
    final petName = petRegisterState.pet?.name ?? '반려동물';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            PetRegisterHeader(title: '$petName의 사진을\n등록하시겠어요?'),
            const SizedBox(height: 24),

            // 이미지 플레이스홀더
            CustomImagePlaceholder(hasImage: _hasImage),
            const SizedBox(height: 24),

            // 카메라 버튼
            ImageSourceButton(
              icon: Icons.camera_alt,
              label: '사진 촬영하기',
              onTap: _takePicture,
            ),
            const SizedBox(height: 16),

            // 갤러리 버튼
            ImageSourceButton(
              icon: Icons.photo_library,
              label: '갤러리에서 찾기',
              onTap: _pickFromGallery,
            ),
            const SizedBox(height: 16),

            // 건너뛰기 버튼
            SkipButton(onSkip: _skipImageAndRegister),
            const SizedBox(height: 16),

            // 이전/다음 버튼
            DualButtons(
              onLeft: _onPrevious,
              onRight: _onNext,
              isLoading: petRegisterState.isLoading,
              leftLabel: '이전',
              rightLabel: '다음',
            ),
          ],
        ),
      ),
    );
  }
}

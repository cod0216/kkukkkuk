import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kkuk_kkuk/data/repositories/image/image_repository_impl.dart';
import 'package:permission_handler/permission_handler.dart';
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
  File? _selectedImage; // 선택된 이미지 파일
  final _imagePicker = ImagePicker();

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
  Future<void> _registerPet() async {
    if (_selectedImage == null) {
      widget.controller.registerPet();
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 이미지 업로드
      final imageRepository = ref.read(imageRepositoryProvider);
      final imageUrl = await imageRepository.uploadPermanentImage(
        _selectedImage!,
        'pet',
      );

      // 반려동물 정보에 이미지 URL 설정
      ref.read(petRegisterProvider.notifier).setImageUrl(imageUrl);

      // 반려동물 등록
      widget.controller.registerPet();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지 업로드 중 오류가 발생했습니다.')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    setState(() {
      _selectedImage = null;
      _hasImage = false;
    });
    _registerPet();
  }

  // 카메라 권한 요청
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  // 갤러리 권한 요청
  Future<bool> _requestGalleryPermission() async {
    // Android 13 (API 33) 이상
    if (Platform.isAndroid) {
      if (await Permission.photos.status.isDenied) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return true;
    }
    // Android 12 이하
    if (await Permission.storage.status.isDenied) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  // 이미지 크롭
  Future<File?> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '이미지 편집',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '이미지 편집',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  // 이미지 처리
  Future<void> _processImage(XFile? pickedImage) async {
    if (pickedImage == null) return;

    final File? croppedImage = await _cropImage(pickedImage.path);
    if (croppedImage == null) return;

    setState(() {
      _selectedImage = croppedImage;
      _hasImage = true;
    });
  }

  // 카메라로 사진 촬영
  Future<void> _takePicture() async {
    if (!await _requestCameraPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카메라 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      await _processImage(image);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진 촬영 중 오류가 발생했습니다.')));
      }
    }
  }

  // 갤러리에서 이미지 선택
  Future<void> _pickFromGallery() async {
    if (!await _requestGalleryPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('갤러리 접근 권한이 필요합니다.')));
      }
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      await _processImage(image);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다.')));
      }
    }
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
            CustomImagePlaceholder(
              hasImage: _hasImage,
              imageFile: _selectedImage,
            ),
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

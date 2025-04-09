import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart'; // Pet import 추가
import 'package:kkuk_kkuk/features/image/api/repositories/image_repository_impl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/pages/pet_register/notifiers/pet_register_notifier.dart';
import 'package:kkuk_kkuk/widgets/pet/card/pet_card.dart'; // PetCard import 추가
import 'package:kkuk_kkuk/widgets/common/image_source_button.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart';
import 'package:kkuk_kkuk/shared/lib/permission/permission_manager.dart';

// 반려동물 이미지 등록 화면
class PetImageView extends ConsumerStatefulWidget {
  const PetImageView({super.key});

  @override
  ConsumerState<PetImageView> createState() => _PetImageViewState();
}

class _PetImageViewState extends ConsumerState<PetImageView> {
  // ... (기존 상태 변수 및 함수들 유지) ...
  final _permissionManager = PermissionManager();
  File? _selectedImage;
  final _imagePicker = ImagePicker();

  void _onPrevious() {
    ref.read(petRegisterNotifierProvider.notifier).moveToPreviousStep();
  }

  void _onNext() {
    // 이미지 선택 여부와 관계없이 다음 단계로 진행 (이미지 없으면 null로 등록됨)
    _registerPet();
    // if (_selectedImage == null) {
    //   _showImageRequiredDialog(); // 이미지 필수 아님 -> 제거
    // } else {
    //   _registerPet();
    // }
  }

  Future<void> _registerPet() async {
    // 이미지 URL 설정 (선택된 이미지가 있으면 업로드, 없으면 기존 값 또는 null 유지)
    String? finalImageUrl;
    if (_selectedImage != null) {
      // 업로드 시작 시 로딩
      try {
        final imageRepository = ref.read(imageRepositoryProvider);
        finalImageUrl = await imageRepository.uploadPermanentImage(
          _selectedImage!,
          'pet', // 도메인 지정
        );
        ref
            .read(petRegisterNotifierProvider.notifier)
            .setImageUrl(finalImageUrl);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 업로드 중 오류: ${e.toString()}')),
          );
          // 오류 시 로딩 해제
          return; // 업로드 실패 시 등록 중단
        }
      } finally {
        if (mounted && finalImageUrl != null) {
          // 성공 시에만 로딩 해제 (등록 과정 계속)
          // setState(() => _isLoading = false); // 등록 과정에서 계속 로딩 표시
        }
      }
    } else {
      // 이미지가 선택되지 않은 경우, 기존 이미지 URL 유지 또는 null 설정
      finalImageUrl = ref.read(petRegisterNotifierProvider).pet?.imageUrl;
      ref
          .read(petRegisterNotifierProvider.notifier)
          .setImageUrl(finalImageUrl ?? ''); // null이면 빈 문자열
    }

    // 로딩 상태 유지하며 반려동물 등록 시도
    await ref.read(petRegisterNotifierProvider.notifier).registerPet();
    // registerPet 내부에서 isLoading과 currentStep을 관리하므로 여기서 로딩 해제 필요 없음
    // if (mounted) {
    //   setState(() => _isLoading = false);
    // }
  }

  Future<File?> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      // PetCard 비율에 맞게 조정 (예: 4:3 또는 16:9)
      // aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '이미지 편집',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original, // 원본 비율로 시작
          lockAspectRatio: false, // 비율 고정 해제
        ),
        IOSUiSettings(
          title: '이미지 편집',
          aspectRatioLockEnabled: false, // 비율 고정 해제
          resetAspectRatioEnabled: true, // 비율 리셋 버튼
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  Future<void> _processImage(XFile? pickedImage) async {
    if (pickedImage == null) return;

    final File? croppedImage = await _cropImage(pickedImage.path);
    if (croppedImage == null) return;

    setState(() {
      _selectedImage = croppedImage;
      // _hasImage = true; // _selectedImage 로 확인
    });
  }

  Future<void> _takePicture() async {
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.camera,
    );
    if (!hasPermission || !context.mounted) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('카메라 접근 권한이 필요합니다.')));
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

  Future<void> _pickFromGallery() async {
    final permission =
        Platform.isAndroid ? Permission.photos : Permission.storage;
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      permission,
    );
    if (!hasPermission || !context.mounted) {
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
    final petRegisterState = ref.watch(petRegisterNotifierProvider);
    // 현재 등록 중인 Pet 객체 가져오기 (null일 수 있음)
    final Pet? petBeingRegistered = petRegisterState.pet;
    final String petName = petBeingRegistered?.name ?? '반려동물';
    final bool isProcessingNext = petRegisterState.isLoading; // 등록 진행 로딩 상태

    return Scaffold(
      // Scaffold 추가 (전체 화면 구성)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              PetRegisterHeader(title: '$petName의 사진을\n등록하시겠어요?'),
              const SizedBox(height: 24),

              // 이미지 플레이스홀더 대신 PetCard 사용
              SizedBox(
                height: 350, // PetCard 높이 지정 (필요에 따라 조절)
                width: double.infinity, // 너비 꽉 채움
                child:
                    petBeingRegistered != null
                        ? PetCard(
                          pet: petBeingRegistered, // 현재까지 입력된 정보로 Pet 객체 전달
                          imageFile: _selectedImage, // 선택된 로컬 파일 전달
                          onTap: (_) {}, // 이 화면에서는 탭 동작 불필요
                        )
                        : const Center(
                          child: CircularProgressIndicator(),
                        ), // Pet 정보 로딩 중
              ),
              const SizedBox(height: 24),

              // 카메라 버튼
              ImageSourceButton(
                icon: Icons.camera_alt_outlined, // 아이콘 변경
                label: '사진 촬영하기',
                onTap: _takePicture,
              ),
              const SizedBox(height: 16),

              // 갤러리 버튼
              ImageSourceButton(
                icon: Icons.photo_library_outlined, // 아이콘 변경
                label: '갤러리에서 찾기',
                onTap: _pickFromGallery,
              ),
              const SizedBox(height: 16),

              // 이전/다음 버튼 (Row 구조)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('이전'),
                      onPressed:
                          isProcessingNext ? null : _onPrevious, // 로딩 중 비활성화
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        disabledForegroundColor: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon:
                          isProcessingNext
                              ? Container()
                              : const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              ), // 아이콘 변경 및 색상 명시
                      label:
                          isProcessingNext
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('등록 완료'), // 라벨 변경
                      onPressed: isProcessingNext ? null : _onNext,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        disabledBackgroundColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

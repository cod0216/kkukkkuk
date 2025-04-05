import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/core/permission/permission_manager.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_detail_response.dart';
import 'package:kkuk_kkuk/domain/entities/user.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/usecases/user/user_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/wallet_usecase_providers.dart';
import 'package:kkuk_kkuk/viewmodels/auth_view_model.dart';
import 'package:kkuk_kkuk/viewmodels/wallet_view_model.dart';

/// 마이페이지 컨트롤러 - 마이페이지의 비즈니스 로직을 처리하는 클래스
class MyPageController {
  final WidgetRef ref;
  final refreshNotifierProvider = StateProvider<int>((ref) => 0);
  final _permissionManager = PermissionManager();
  final _imagePicker = ImagePicker();

  MyPageController(this.ref);

  /// 화면 새로고침 트리거
  /// TODO: User 데이터 갱신 방법 개선 필요
  void triggerRefresh() {
    ref.read(refreshNotifierProvider.notifier).state++;
  }

  /// 이미지 크롭 처리
  Future<File?> _cropImage(BuildContext context, String imagePath) async {
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

  /// 이미지 처리 - 펫 이미지 뷰의 로직 참고하여 수정
  Future<File?> _processImage(BuildContext context, XFile pickedImage) async {
    try {
      // 이미지 크롭 처리
      final File? croppedImage = await _cropImage(context, pickedImage.path);
      print('croppedImage: $croppedImage');
      print('pickedImage: $pickedImage');
      print('pickedImage.path: ${pickedImage.path}');
      return croppedImage;
    } catch (e) {
      print('이미지 처리 중 오류 발생: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 처리 중 오류가 발생했습니다: $e')));
      }
      return null;
    }
  }

  /// 이미지 업로드
  Future<void> _uploadImage(BuildContext context, File croppedImage) async {
    // 로딩 다이얼로그 표시
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('프로필 이미지 업로드 중...'),
                ],
              ),
            ),
      );
    }

    try {
      // 프로필 이미지 업로드 유스케이스 호출
      final uploadProfileImageUseCase = ref.read(
        uploadProfileImageUseCaseProvider,
      );
      await uploadProfileImageUseCase.execute(croppedImage);

      // 화면 새로고침
      triggerRefresh();

      // 로딩 다이얼로그 닫기
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // 성공 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 이미지가 업데이트되었습니다.')));
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('프로필 이미지 업로드 실패: $e')));
      }
    }
  }

  /// 카메라로 사진 촬영
  Future<void> _takePicture(BuildContext context) async {
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.camera,
    );

    if (!hasPermission) {
      if (context.mounted) {
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

      if (image != null && context.mounted) {
        final File? processedImage = await _processImage(context, image);
        if (processedImage != null && context.mounted) {
          await _uploadImage(context, processedImage);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('사진 촬영 중 오류가 발생했습니다: $e')));
      }
    }
  }

  /// 갤러리에서 이미지 선택
  Future<void> _pickFromGallery(BuildContext context) async {
    final permission =
        Platform.isAndroid ? Permission.photos : Permission.storage;

    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      permission,
    );

    if (!hasPermission) {
      if (context.mounted) {
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
      print('image: $image');
      print('image.mt: ${image?.mimeType}');
      print('image.path: ${image?.path}');

      if (image != null && context.mounted) {
        final File? processedImage = await _processImage(context, image);
        if (processedImage != null && context.mounted) {
          await _uploadImage(context, processedImage);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')));
      }
    }
  }

  /// 사용자 정보 새로고침
  Future<User?> refreshUserInfo() async {
    try {
      final getUserProfileUseCase = ref.read(getUserProfileUseCaseProvider);
      return await getUserProfileUseCase.execute();
    } catch (e) {
      print('사용자 정보 조회 실패: $e');
      rethrow;
    }
  }

  /// 로그아웃 처리 함수
  Future<void> handleLogout(BuildContext context) async {
    try {
      // 로그아웃 유스케이스 호출
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase.execute();

      // 로그아웃 후 상태 초기화
      ref.read(authViewModelProvider.notifier).reset();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다.')));
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
      }
    }
  }

  /// 지갑 정보 삭제 함수
  Future<void> handleWalletChange(BuildContext context) async {
    ref.read(walletViewModelProvider.notifier).reset();

    if (context.mounted) {
      context.push('/wallet-creation', extra: walletViewModelProvider);
    }
  }

  /// 지갑 상세 정보 조회 함수
  Future<WalletDetailResponse?> getWalletDetail(int walletId) async {
    try {
      final getWalletDetailUseCase = ref.read(getWalletDetailUseCaseProvider);
      final response = await getWalletDetailUseCase.execute(walletId);
      return response;
    } catch (e) {
      print('지갑 상세 정보 조회 실패: $e');
      return null;
    }
  }

  /// 지갑 소유자 정보를 포함한 지갑 목록 조회
  Future<List<Wallet>> getWalletsWithOwners(List<Wallet> wallets) async {
    final List<Wallet> updatedWallets = [];

    for (final wallet in wallets) {
      try {
        final detailResponse = await getWalletDetail(wallet.id);
        if (detailResponse != null) {
          // DTO에서 엔티티로 변환
          final owners =
              detailResponse.data.owners
                  .map(
                    (ownerDto) => Owner(
                      id: ownerDto.id,
                      name: ownerDto.name,
                      image: ownerDto.image,
                    ),
                  )
                  .toList();

          // 소유자 정보가 포함된 새 지갑 객체 생성
          final updatedWallet = Wallet(
            id: wallet.id,
            address: wallet.address,
            name: wallet.name,
            owners: owners,
          );

          updatedWallets.add(updatedWallet);
        } else {
          updatedWallets.add(wallet);
        }
      } catch (e) {
        print('지갑 $wallet 소유자 정보 조회 실패: $e');
        updatedWallets.add(wallet);
      }
    }

    return updatedWallets;
  }

  /// 지갑 이름 수정 함수
  Future<void> updateWalletName(int walletId, String newName) async {
    try {
      final updateWalletUseCase = ref.read(updateWalletUseCaseProvider);
      await updateWalletUseCase.execute(walletId: walletId, name: newName);
      triggerRefresh(); // Add this line
    } catch (e) {
      print('지갑 이름 수정 실패: $e');
      rethrow;
    }
  }

  /// 지갑 삭제 함수
  Future<void> deleteWallet(int walletId) async {
    try {
      final deleteWalletUseCase = ref.read(deleteWalletUseCaseProvider);
      await deleteWalletUseCase.execute(walletId);
      triggerRefresh(); // Add this line
    } catch (e) {
      print('지갑 삭제 실패: $e');
      rethrow;
    }
  }

  /// 프로필 이미지 변경 다이얼로그 표시
  Future<void> showProfileImageDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('프로필 이미지 변경'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 카메라 옵션
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('카메라로 촬영'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePicture(context);
                  },
                ),
                // 갤러리 옵션
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('갤러리에서 선택'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickFromGallery(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
            ],
          ),
    );
  }
}

/// 마이페이지 컨트롤러 프로바이더
final myPageControllerProvider = Provider.family<MyPageController, WidgetRef>(
  (ref, widgetRef) => MyPageController(widgetRef),
);

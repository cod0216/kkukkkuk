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

  /// 이미지 업로드
  Future<void> _uploadImage(BuildContext context, File croppedImage) async {
    // 컨텍스트가 유효한지 확인
    if (!context.mounted) return;

    // 로딩 다이얼로그를 표시하고 BuildContext를 저장
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('프로필 이미지 업로드 중...'),
            ],
          ),
        );
      },
    );

    try {
      // 프로필 이미지 업로드 유스케이스 호출
      final uploadProfileImageUseCase = ref.read(
        uploadProfileImageUseCaseProvider,
      );
      await uploadProfileImageUseCase.execute(croppedImage);

      // 로딩 다이얼로그 닫기 - 저장된 dialogContext 사용
      if (dialogContext != null &&
          Navigator.of(dialogContext!, rootNavigator: true).canPop()) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }

      // 성공 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 이미지가 업데이트되었습니다.')));
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기 - 저장된 dialogContext 사용
      if (dialogContext != null &&
          Navigator.of(dialogContext!, rootNavigator: true).canPop()) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('프로필 이미지 업로드 실패: $e')));
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
    final ImageSource? source = await showDialog<ImageSource>(
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
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                // 갤러리 옵션
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('갤러리에서 선택'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('취소'),
              ),
            ],
          ),
    );

    // 사용자가 취소했거나 대화 상자가 닫혔일 때
    if (source == null || !context.mounted) return;

    // 선택된 소스에 따라 이미지 처리
    if (source == ImageSource.camera) {
      await _takePicture(context);
    } else {
      await _pickFromGallery(context);
    }
  }

  /// 카메라로 사진 촬영
  Future<void> _takePicture(BuildContext context) async {
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.camera,
    );

    if (!hasPermission || !context.mounted) {
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

      // 이미지가 선택되지 않았거나 컨텍스트가 유효하지 않은 경우
      if (image == null || !context.mounted) return;

      // 이미지 크롭 처리
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
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

      // 크롭된 이미지가 없거나 컨텍스트가 유효하지 않은 경우
      if (croppedFile == null || !context.mounted) return;

      // 이미지 업로드
      await _uploadImage(context, File(croppedFile.path));
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

    if (!hasPermission || !context.mounted) {
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

      // 이미지가 선택되지 않았거나 컨텍스트가 유효하지 않은 경우
      if (image == null || !context.mounted) return;

      // 이미지 크롭 처리
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
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

      // 크롭된 이미지가 없거나 컨텍스트가 유효하지 않은 경우
      if (croppedFile == null || !context.mounted) return;

      // 이미지 업로드
      await _uploadImage(context, File(croppedFile.path));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')));
      }
    }
  }
}

/// 마이페이지 컨트롤러 프로바이더
final myPageControllerProvider = Provider.family<MyPageController, WidgetRef>(
  (ref, widgetRef) => MyPageController(widgetRef),
);

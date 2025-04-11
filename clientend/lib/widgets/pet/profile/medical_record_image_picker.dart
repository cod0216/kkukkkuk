import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/shared/lib/permission/permission_manager.dart';

class MedicalRecordImagePicker {
  final BuildContext context;
  final Function(File) onImageSelected;

  final ImagePicker _imagePicker = ImagePicker();
  final _permissionManager = PermissionManager();

  MedicalRecordImagePicker({
    required this.context,
    required this.onImageSelected,
  });

  void showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('진료기록 이미지 선택'),
            content: const Text('진료기록 이미지를 어떤 방식으로 추가하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                child: const Text('카메라로 촬영'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                child: const Text('갤러리에서 선택'),
              ),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final permission =
          source == ImageSource.camera
              ? Permission.camera
              : Platform.isAndroid
              ? Permission.photos
              : Permission.storage;

      final hasPermission = await _permissionManager.handlePermissionRequest(
        context,
        permission,
      );

      if (!hasPermission) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? '카메라 접근 권한이 필요합니다.'
                  : '갤러리 접근 권한이 필요합니다.',
            ),
          ),
        );
        return;
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile == null) return;
      if (!context.mounted) return;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => WillPopScope(
              onWillPop: () async => false,
              child: const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('이미지를 처리하는 중입니다...\n잠시만 기다려주세요.'),
                  ],
                ),
              ),
            ),
      );

      // Call the callback with the selected image
      onImageSelected(File(pickedFile.path));

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지가 선택되었습니다. OCR 처리 예정입니다.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/shared/lib/permission/permission_manager.dart';
// PrimaryButton import 추가 (실제 경로에 맞게 수정)
import 'package:kkuk_kkuk/widgets/common/primary_button.dart';

class QrScanButton extends StatelessWidget {
  final VoidCallback? onTap;
  final _permissionManager = PermissionManager();

  QrScanButton({super.key, this.onTap});

  // QR 스캔 처리 로직 (카메라 권한 확인 및 스캐너 화면 이동)
  Future<void> _handleQrScan(BuildContext context) async {
    // ... (기존 _handleQrScan 코드는 변경 없음)
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.camera,
    );

    if (hasPermission) {
      if (context.mounted) {
        if (onTap != null) {
          onTap!();
        } else {
          context.push('/qr-scanner');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 버튼 주변 여백
      padding: const EdgeInsets.all(16.0),
      // PrimaryButton 사용
      child: PrimaryButton(
        text: '병원의 QR코드를 찍어주세요',
        onPressed: () => _handleQrScan(context),
        // 아이콘 추가
        leadingIcon: const Icon(Icons.qr_code, size: 24),
        // 아이콘과 텍스트 간격 조정 (PrimaryButton 기본값 사용 또는 지정)
        // iconSpacing: 12,
        // 배경색 지정 (기본 PrimaryButton 스타일을 따르거나 여기서 오버라이드)
        // backgroundColor: Colors.blue.shade700,
        // textColor: Colors.white, // PrimaryButton 기본값이 흰색이므로 생략 가능
        isFullWidth: true, // 기본값이 true 이므로 생략 가능
      ),
    );
  }
}

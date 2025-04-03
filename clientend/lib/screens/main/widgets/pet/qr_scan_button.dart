import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kkuk_kkuk/core/permission/permission_manager.dart';

class QrScanCard extends StatelessWidget {
  final VoidCallback? onTap;
  final _permissionManager = PermissionManager();

  QrScanCard({super.key, this.onTap});

  Future<void> _handleQrScan(BuildContext context) async {
    final hasPermission = await _permissionManager.handlePermissionRequest(
      context,
      Permission.camera,
    );

    if (hasPermission) {
      if (context.mounted) {
        context.push('/qr-scanner');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleQrScan(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code, size: 32),
                const SizedBox(width: 16),
                const Text(
                  '병원의 QR코드를 찍어주세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

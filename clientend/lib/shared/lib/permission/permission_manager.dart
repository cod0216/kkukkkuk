import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionInfo {
  final Permission permission;
  final String name;
  final String description;
  PermissionStatus? status;

  PermissionInfo({
    required this.permission,
    required this.name,
    required this.description,
    this.status,
  });

  Future<void> checkStatus() async {
    status = await permission.status;
  }

  Future<bool> request() async {
    status = await permission.request();
    return status?.isGranted ?? false;
  }
}

/// 앱 전체에서 사용할 수 있는 권한 관리 클래스
class PermissionManager {
  // Singleton pattern
  static final PermissionManager _instance = PermissionManager._internal();
  factory PermissionManager() => _instance;
  PermissionManager._internal();

  // 앱에서 사용하는 모든 권한 정보
  final List<PermissionInfo> permissions = [
    PermissionInfo(
      permission: Permission.camera,
      name: '카메라',
      description: '사진 및 동영상 촬영을 위해 카메라 접근 권한이 필요합니다.',
    ),
    PermissionInfo(
      permission: Permission.photos,
      name: '사진',
      description: '사진 접근 권한이 필요합니다.',
    ),
    PermissionInfo(
      permission: Permission.location,
      name: '위치',
      description: '현재 위치 기반 서비스 제공을 위해 위치 접근 권한이 필요합니다.',
    ),
  ];

  /// 모든 권한의 상태를 확인합니다.
  Future<void> checkAllPermissions() async {
    for (var permissionInfo in permissions) {
      await permissionInfo.checkStatus();
    }
  }

  /// 특정 권한 정보를 가져옵니다.
  PermissionInfo? getPermissionInfo(Permission permission) {
    try {
      return permissions.firstWhere((p) => p.permission == permission);
    } catch (e) {
      return null;
    }
  }

  /// 특정 권한의 상태를 확인합니다.
  Future<PermissionStatus> checkPermission(Permission permission) async {
    PermissionInfo? permissionInfo = getPermissionInfo(permission);
    if (permissionInfo != null) {
      await permissionInfo.checkStatus();
      return permissionInfo.status ?? PermissionStatus.denied;
    }
    return await permission.status;
  }

  /// 특정 권한을 요청합니다.
  Future<bool> requestPermission(Permission permission) async {
    PermissionInfo? permissionInfo = getPermissionInfo(permission);
    if (permissionInfo != null) {
      return await permissionInfo.request();
    }
    final status = await permission.request();
    return status.isGranted;
  }

  /// 권한 요청 전 사용자에게 권한이 필요한 이유를 설명하는 다이얼로그를 표시합니다.
  Future<bool> showPermissionRationaleDialog(
    BuildContext context,
    Permission permission,
  ) async {
    PermissionInfo? permissionInfo = getPermissionInfo(permission);
    if (permissionInfo == null) return false;

    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('${permissionInfo.name} 권한 필요'),
                content: Text(permissionInfo.description),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('확인'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  /// 권한이 영구적으로 거부된 경우 설정으로 이동하는 다이얼로그를 표시합니다.
  Future<void> showSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('권한 설정'),
            content: const Text('일부 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                child: const Text('설정으로 이동'),
              ),
            ],
          ),
    );
  }

  /// 앱 설정 화면을 엽니다.
  Future<void> openSettings() async {
    await openAppSettings();
  }

  /// 권한 요청 프로세스를 처리합니다.
  /// 1. 권한이 이미 부여되었는지 확인
  /// 2. 권한 설명 다이얼로그 표시
  /// 3. 권한 요청
  /// 4. 결과에 따라 적절한 조치 수행
  Future<bool> handlePermissionRequest(
    BuildContext context,
    Permission permission, {
    bool showRationale = true,
  }) async {
    // 권한 상태 확인
    final status = await checkPermission(permission);

    // 이미 권한이 부여된 경우
    if (status.isGranted) {
      return true;
    }

    // 권한 설명 다이얼로그 표시
    if (showRationale) {
      bool shouldRequest = await showPermissionRationaleDialog(
        context,
        permission,
      );
      if (!shouldRequest) return false;
    }

    // 권한 요청
    bool isGranted = await requestPermission(permission);

    // 영구 거부된 경우 설정으로 이동 안내
    if (!isGranted) {
      final newStatus = await checkPermission(permission);
      if (newStatus.isPermanentlyDenied) {
        await showSettingsDialog(context);
      }
    }

    return isGranted;
  }

  /// 권한 상태에 따른 텍스트를 반환합니다.
  String getStatusText(PermissionStatus? status) {
    if (status == null) return '확인 중...';
    if (status.isGranted) return '허용됨';
    if (status.isDenied) return '거부됨';
    if (status.isPermanentlyDenied) return '영구 거부됨';
    if (status.isRestricted) return '제한됨';
    if (status.isLimited) return '제한적 허용';
    return '알 수 없음';
  }

  /// 권한 상태에 따른 아이콘을 반환합니다.
  Widget getStatusIcon(PermissionStatus? status) {
    if (status == null) {
      return const CircularProgressIndicator();
    }

    IconData iconData;
    Color iconColor;

    if (status.isGranted) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else if (status.isDenied) {
      iconData = Icons.cancel;
      iconColor = Colors.red;
    } else if (status.isPermanentlyDenied) {
      iconData = Icons.block;
      iconColor = Colors.red;
    } else if (status.isRestricted || status.isLimited) {
      iconData = Icons.warning;
      iconColor = Colors.orange;
    } else {
      iconData = Icons.help;
      iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor);
  }
}

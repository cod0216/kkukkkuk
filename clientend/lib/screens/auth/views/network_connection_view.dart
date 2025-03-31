import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';
import 'package:kkuk_kkuk/providers/network/network_connection_provider.dart';

/// 네트워크 연결 화면
class NetworkConnectionView extends ConsumerStatefulWidget {
  final AuthController controller;

  const NetworkConnectionView({super.key, required this.controller});

  @override
  ConsumerState<NetworkConnectionView> createState() =>
      _NetworkConnectionViewState();
}

class _NetworkConnectionViewState extends ConsumerState<NetworkConnectionView> {
  @override
  void initState() {
    super.initState();
    _connectToNetwork();
  }

  /// 네트워크 연결 시도
  Future<void> _connectToNetwork() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(networkConnectionProvider.notifier).connectToNetwork().then((
        success,
      ) {
        if (success) {
          widget.controller.completeAuth();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final networkState = ref.watch(networkConnectionProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIcon(networkState.status),
            const SizedBox(height: 24),
            _buildStatusText(context, networkState),
            const SizedBox(height: 32),
            if (networkState.status == NetworkConnectionStatus.failed)
              ElevatedButton(
                onPressed: () => _connectToNetwork(),
                child: const Text('다시 시도'),
              ),
          ],
        ),
      ),
    );
  }

  /// 상태 아이콘 표시
  Widget _buildStatusIcon(NetworkConnectionStatus status) {
    switch (status) {
      case NetworkConnectionStatus.connecting:
        return const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        );
      case NetworkConnectionStatus.connected:
        return const Icon(Icons.check_circle, color: Colors.green, size: 48);
      case NetworkConnectionStatus.failed:
        return const Icon(Icons.error, color: Colors.red, size: 48);
      default:
        return const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        );
    }
  }

  /// 상태 텍스트 표시
  Widget _buildStatusText(BuildContext context, NetworkConnectionState state) {
    String message;

    switch (state.status) {
      case NetworkConnectionStatus.connecting:
        message = '블록체인 네트워크에 연결 중입니다...\n잠시만 기다려주세요.';
        break;
      case NetworkConnectionStatus.connected:
        message = '블록체인 네트워크에 연결되었습니다!\n메인 화면으로 이동합니다.';
        break;
      case NetworkConnectionStatus.failed:
        message = '블록체인 네트워크 연결에 실패했습니다.\n${state.error ?? ""}';
        break;
      default:
        message = '블록체인 네트워크 연결 준비 중...';
    }

    return Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }
}

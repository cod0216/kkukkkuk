import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/pages/splash/notifiers/splash_notifier.dart';
import 'package:kkuk_kkuk/pages/splash/states/splash_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusIndicator extends ConsumerWidget {
  final SplashState state;

  const StatusIndicator({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == SplashStatus.connecting ||
        state.status == SplashStatus.initializing) {
      return const Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "네트워크 연결 중...",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      );
    } else if (state.status == SplashStatus.failed) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            size: 30,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              state.error ?? "네트워크 연결에 실패했습니다. 인터넷 연결을 확인 후 다시 시도해주세요.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                ref.read(splashNotifierProvider.notifier).retryConnection(),
            child: const Text(
              "다시 시도",
              style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(height: 80); // 공간 확보
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/auth_controller.dart';

class WalletGuideView extends ConsumerWidget {
  final AuthController controller;

  const WalletGuideView({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지갑 생성 안내',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '블록체인 지갑은 디지털 자산을 안전하게 보관하고 관리하는 도구입니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '• 니모닉 단어를 통해 지갑을 생성하거나 복구할 수 있습니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• 니모닉 단어는 반드시 안전하게 보관해야 합니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• 지갑 생성 후에는 니모닉 단어를 확인하는 과정이 있습니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.moveToWalletCreation(context),
            child: const Text('지갑 생성하기'),
          ),
        ],
      ),
    );
  }
}
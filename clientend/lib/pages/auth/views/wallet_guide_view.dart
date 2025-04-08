import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/auth/notifiers/auth_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/custom_button.dart';

class WalletGuideView extends ConsumerWidget {
  final AuthNotifier viewModel;

  const WalletGuideView({super.key, required this.viewModel});

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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
          CustomButton(
            onPressed: () => viewModel.moveToWalletCreation(context),
            text: ('지갑 생성하기'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/providers/wallet_provider.dart';

class WalletCreationScreen extends ConsumerStatefulWidget {
  const WalletCreationScreen({super.key});

  @override
  ConsumerState<WalletCreationScreen> createState() =>
      _WalletCreationScreenState();
}

class _WalletCreationScreenState extends ConsumerState<WalletCreationScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: 서버에서 지갑 존재 유무를 확인하는 로직 추가 예정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).createWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('꾹꾹'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // 상태에 따라 다른 화면 표시
            if (walletState.creationState == WalletCreationState.creating)
              _buildCreatingState()
            else if (walletState.creationState == WalletCreationState.created)
              _buildCreatedState(walletState.walletAddress!)
            else if (walletState.creationState == WalletCreationState.error)
              _buildErrorState(walletState.errorMessage!),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '지갑을 생성중입니다.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildCreatedState(String walletAddress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '지갑 생성이 완료되었습니다.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration, size: 50, color: Colors.amber.shade700),
                const SizedBox(height: 10),
                const Text(
                  '축하합니다!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '지갑 주소: $walletAddress',
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            // TODO: 다음 화면으로 이동
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('완료', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '지갑 생성 중 오류가 발생했습니다.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          errorMessage,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            ref.read(walletProvider.notifier).reset();
            ref.read(walletProvider.notifier).createWallet();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('다시 시도', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/models/sharing_state.dart';
import 'package:kkuk_kkuk/controllers/sharing_controller.dart';

class SharingResultView extends ConsumerStatefulWidget {
  final Pet pet;
  final HospitalQRData hospital;

  const SharingResultView({
    super.key,
    required this.pet,
    required this.hospital,
  });

  @override
  ConsumerState<SharingResultView> createState() => _SharingResultViewState();
}

class _SharingResultViewState extends ConsumerState<SharingResultView> {
  @override
  void initState() {
    super.initState();
    // 권한 부여 시작
    Future.microtask(() {
      ref
          .read(sharingProvider.notifier)
          .startSharing(pet: widget.pet, hospital: widget.hospital);
    });
  }

  // 트랜잭션 해시 복사
  Future<void> _copyTransactionHash(String hash) async {
    await Clipboard.setData(ClipboardData(text: hash));
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('트랜잭션 해시가 복사되었습니다')));
  }

  // 재시도 로직
  void _retry() {
    ref
        .read(sharingProvider.notifier)
        .startSharing(pet: widget.pet, hospital: widget.hospital);
  }

  @override
  Widget build(BuildContext context) {
    final sharingState = ref.watch(sharingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('권한 부여 결과'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: switch (sharingState.status) {
            SharingStatus.processing => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text('병원에 권한 부여 중...'),
              ],
            ),
            SharingStatus.success => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                const Text(
                  '권한 부여 완료',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '${sharingState.pet?.name}의 진료 기록에 대한 접근 권한이\n${sharingState.hospital?.name}에 부여되었습니다.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                if (sharingState.transactionHash != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    '트랜잭션 해시:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap:
                        () =>
                            _copyTransactionHash(sharingState.transactionHash!),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              sharingState.transactionHash!,
                              style: const TextStyle(fontFamily: 'monospace'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.copy, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.go('/pets'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('홈으로 돌아가기'),
                ),
              ],
            ),
            SharingStatus.error => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 80, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  '권한 부여 실패',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '${sharingState.hospital?.name}에 권한을 부여하는 중\n오류가 발생했습니다.\n${sharingState.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('다시 시도'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () => context.go('/pets'),
                      child: const Text('반려동물 목록으로'),
                    ),
                  ],
                ),
              ],
            ),
            _ => const SizedBox(),
          },
        ),
      ),
    );
  }
}

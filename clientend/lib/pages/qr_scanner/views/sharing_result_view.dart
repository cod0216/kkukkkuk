import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/states/sharing_state.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/notifiers/pet_sharing_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/loading_indicator.dart'; // LoadingIndicator 사용
import 'package:kkuk_kkuk/widgets/common/primary_button.dart'; // PrimaryButton 사용
import 'package:kkuk_kkuk/widgets/common/status_indicator.dart'; // StatusIndicator 사용

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
    Future.microtask(() {
      ref
          .read(petSharingNotifierProvider.notifier)
          .startSharing(pet: widget.pet, hospital: widget.hospital);
    });
  }

  void _retry() {
    ref
        .read(petSharingNotifierProvider.notifier)
        .startSharing(pet: widget.pet, hospital: widget.hospital);
  }

  @override
  Widget build(BuildContext context) {
    final sharingState = ref.watch(petSharingNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: switch (sharingState.status) {
            // 로딩 상태 (LoadingIndicator 사용)
            SharingStatus.processing => const LoadingIndicator(
              message: '병원에 권한 부여 중...',
            ),
            // 성공 상태 (StatusIndicator 사용)
            SharingStatus.success => SharingSuccessContent(
              sharingState: sharingState,
            ),
            // 에러 상태 (StatusIndicator 및 버튼 스타일 수정)
            SharingStatus.error => SharingErrorContent(
              sharingState: sharingState,
              onRetry: _retry,
            ),
            // 초기 상태 등 (보통 표시되지 않음)
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

// 성공 시 표시될 컨텐츠 위젯
class SharingSuccessContent extends StatelessWidget {
  const SharingSuccessContent({super.key, required this.sharingState});

  final SharingState sharingState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // StatusIndicator 사용
        StatusIndicator(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          iconSize: 80,
          message: '권한 부여 완료',
          messageStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24), // 간격 조정
        Text(
          '${sharingState.pet?.name}의 진료 기록 접근 권한이\n${sharingState.hospital?.name}에 부여되었습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.4,
          ), // 스타일 조정
        ),
        const SizedBox(height: 40), // 간격 조정
        // PrimaryButton 사용
        PrimaryButton(
          text: '홈으로 돌아가기',
          onPressed: () => context.go('/pets'),
          isFullWidth: false, // 버튼 너비 자동 조절
          leadingIcon: const Icon(Icons.home_outlined, size: 20),
        ),
      ],
    );
  }
}

// 에러 시 표시될 컨텐츠 위젯
class SharingErrorContent extends StatelessWidget {
  const SharingErrorContent({
    super.key,
    required this.sharingState,
    required this.onRetry,
  });

  final SharingState sharingState;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // StatusIndicator 사용 (에러 아이콘)
        StatusIndicator(
          icon: Icons.error_outline,
          iconColor: Colors.red.shade700,
          iconSize: 80,
          message: '권한 부여 실패',
          messageStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${sharingState.hospital?.name}에 권한을 부여하는 중 오류가 발생했습니다.\n${sharingState.errorMessage ?? '알 수 없는 오류'}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 40),
        // 버튼 스타일 수정 (Row 사용)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // OutlinedButton 사용 (취소 또는 다른 동작)
            OutlinedButton(
              onPressed: () => context.go('/pets'), // 홈으로 가기
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child: const Text('홈으로'),
            ),
            const SizedBox(width: 16),
            // PrimaryButton 사용 (재시도)
            PrimaryButton(
              text: '다시 시도',
              onPressed: onRetry,
              isFullWidth: false,
              leadingIcon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}

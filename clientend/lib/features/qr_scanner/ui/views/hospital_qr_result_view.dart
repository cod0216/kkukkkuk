import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';

class HospitalQRResultView extends ConsumerWidget {
  final HospitalQRData hospitalData;

  const HospitalQRResultView({super.key, required this.hospitalData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      // 뒤로 가기 시 스캐너 화면으로 돌아가면서 스캐너 재시작
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('병원 정보'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(context, title: '병원명', content: hospitalData.name),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: '주소',
                content: hospitalData.address,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(context, title: 'DID', content: hospitalData.did),
              const SizedBox(height: 24),
              // 선택 버튼 추가
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 펫 선택 화면으로 이동
                    context.push(
                      '/qr-scanner/pet-selection',
                      extra: hospitalData,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('이 병원에 권한 부여하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

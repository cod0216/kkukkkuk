import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 사용
import 'package:kkuk_kkuk/widgets/common/primary_button.dart'; // PrimaryButton 사용
import 'package:kkuk_kkuk/widgets/qr_scanner/hospital_info_card.dart'; // 수정된 Card 사용

class HospitalQRResultView extends ConsumerWidget {
  final HospitalQRData hospitalData;

  const HospitalQRResultView({super.key, required this.hospitalData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(); // 스캐너 재시작 로직은 라우트에서 관리될 수 있음
        return true; // 기본 뒤로가기 허용 (필요시 false로 변경)
      },
      child: Scaffold(
        appBar: CustomAppBar(), // 공통 AppBar 사용
        body: SafeArea(
          // SafeArea 추가
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 추가
                const CustomHeader(
                  title: '병원 정보 확인',
                  subtitle: '스캔된 QR코드의 병원 정보입니다.\n정보 확인 후 권한을 부여해주세요.',
                ),
                const SizedBox(height: 16), // 헤더와 카드 사이 간격
                // 수정된 HospitalInfoCard 사용
                HospitalInfoCard(
                  context: context,
                  title: '병원명',
                  content: hospitalData.name,
                ),
                const SizedBox(height: 12), // 카드 간 간격 조정
                HospitalInfoCard(
                  context: context,
                  title: '주소',
                  content: hospitalData.address,
                ),
                const SizedBox(height: 12),
                HospitalInfoCard(
                  context: context,
                  title: 'DID',
                  content: hospitalData.did,
                ),
                const Spacer(), // 버튼을 하단으로 밀기
                // 버튼 스타일 변경 (PrimaryButton 사용)
                PrimaryButton(
                  text: '이 병원에 권한 부여하기',
                  onPressed: () {
                    context.push(
                      '/qr-scanner/pet-selection',
                      extra: hospitalData,
                    );
                  },
                  // 아이콘 추가 (선택 사항)
                  leadingIcon: const Icon(
                    Icons.health_and_safety_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 16), // 하단 여백
              ],
            ),
          ),
        ),
      ),
    );
  }
}

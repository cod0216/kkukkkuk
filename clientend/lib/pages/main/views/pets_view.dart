import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/main/notifiers/pet_notifier.dart';
import 'package:kkuk_kkuk/widgets/main/add_pet_button.dart';
import 'package:kkuk_kkuk/widgets/pet/pet_carousel.dart';
import 'package:kkuk_kkuk/widgets/main/qr_scan_button.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView>
    with AutomaticKeepAliveClientMixin {
  // ... (기존 _navigateToPetRegister, _onPetTap, _refreshPetList, didChangeDependencies 메서드 유지) ...
  void _navigateToPetRegister() {
    context.push('/pet-register').then((_) {
      _refreshPetList();
    });
  }

  void _onPetTap(BuildContext context, Pet pet) {
    context.push('/pet-detail', extra: pet).then((_) {
      _refreshPetList();
    });
  }

  Future<void> _refreshPetList() async {
    print('PetsView: _refreshPetList called by RefreshIndicator');
    await ref.read(petNotifierProvider.notifier).getPetList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petNotifierProvider.notifier).getPetList();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final petState = ref.watch(petNotifierProvider);
    final pets = petState.pets;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshPetList,
        child: Column(
          // 전체 구조 Column
          children: [
            Expanded(
              // 스크롤 가능한 영역
              child: ListView(
                padding: EdgeInsets.zero, // ListView 기본 패딩 제거
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // 1. 캐러셀 상단 여백
                  const SizedBox(height: 24.0), // 값 조절

                  if (petState.isLoading && pets.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (pets.isEmpty)
                    // 펫 없을 때: AddPetButton (큰 카드 형태)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 50.0,
                      ),
                      // AddPetButton 자체가 크므로 내부 Column 사용 안 함
                      child: AddNewPetInlineButton(
                        onTap: _navigateToPetRegister,
                      ),
                    )
                  else
                    // 펫 있을 때: 캐러셀 + 추가 버튼
                    Column(
                      children: [
                        PetCarousel(
                          pets: pets,
                          onPetTap: (pet) => _onPetTap(context, pet),
                        ),
                        // 2. 캐러셀과 '+' 버튼 사이 여백
                        const SizedBox(height: 20.0), // 값 조절
                        AddNewPetInlineButton(onTap: _navigateToPetRegister),
                      ],
                    ),
                  // 3. '+' 버튼과 '병원 찾기' 버튼 사이 여백 (ListView 마지막에 추가)
                  const SizedBox(height: 24.0), // 값 조절
                ],
              ),
            ), // Expanded 끝
            // --- 고정 버튼 영역 ---
            // 4. '병원 찾기' 버튼과 'QR 스캔' 버튼 사이 여백
            FindHospitalButton(), // TODO: FindHospitalButton 구현 확인
            const SizedBox(height: 8.0), // 값 조절
            QrScanButton(
              onTap: () {
                context.push('/qr-scanner');
              },
            ),
            // 5. 'QR 스캔' 버튼 하단 여백 (QrScanButton 위젯 내부에 Padding(16)이 이미 있음)
            // 추가 여백 필요시 SizedBox(height: 16.0) 추가
          ],
        ),
      ),
    );
  }
}

// TODO: FindHospitalButton 위젯을 정의하거나 import 해야 합니다.
// 임시 FindHospitalButton 정의 (실제 구현으로 대체 필요)
class FindHospitalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        0,
      ), // QrScanButton과 좌우 패딩 맞춤
      child: ElevatedButton(
        onPressed: () {
          context.push('/map');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // 이미지의 주황색 버튼
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 20), // 임시 아이콘
            SizedBox(width: 8),
            Text(
              '가까운 병원 찾기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

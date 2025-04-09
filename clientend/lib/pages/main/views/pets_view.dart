import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/main/notifiers/pet_notifier.dart';
import 'package:kkuk_kkuk/widgets/main/add_pet_button.dart';
import 'package:kkuk_kkuk/widgets/pet/empty_pet_placeholder_card.dart';
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
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 24.0),
                  // -- 펫 카드 영역 --
                  if (petState.isLoading && pets.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (pets.isEmpty)
                    Column(
                      children: [
                        EmptyPetPlaceholderCard(onTap: _navigateToPetRegister),
                      ],
                    )
                  else
                    Column(
                      children: [
                        PetCarousel(
                          pets: pets,
                          onPetTap: (pet) => _onPetTap(context, pet),
                        ),
                      ],
                    ),

                  // -- 버튼 영역 --
                  const SizedBox(height: 24.0),
                  AddNewPetInlineButton(onTap: _navigateToPetRegister),
                  const SizedBox(height: 24.0),

                  FindHospitalButton(), // TODO: FindHospitalButton 구현 확인
                  const SizedBox(height: 16.0),
                  QrScanButton(
                    onTap: () {
                      context.push('/qr-scanner');
                    },
                  ),
                ],
              ),
            ),
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
          // TODO: 가까운 병원 찾기 기능 구현
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('구현중인 기능입니다.'),
              duration: Duration(seconds: 1),
            ),
          );
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_provider.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/add_pet_button.dart';
import 'package:kkuk_kkuk/widgets/add_circle_icon.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/pet_carousel.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/qr_scan_button.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView>
    with AutomaticKeepAliveClientMixin {
  void _navigateToPetRegister() {
    context.push('/pet-register').then((_) {
      // 펫 등록 화면에서 돌아왔을 때
      print('PetsView: Navigated back from /pet-register'); // 클래스 이름 변경
      _refreshPetList();
    });
  }

  void _onPetTap(BuildContext context, Pet pet) {
    context.push('/pet-detail', extra: pet).then((_) {
      // 펫 상세 화면에서 돌아왔을 때
      print('PetsView: Navigated back from /pet-detail'); // 클래스 이름 변경
      _refreshPetList();
    });
  }

  void _refreshPetList() {
    // initState 이후에도 호출될 수 있으므로 addPostFrameCallback 제거
    print('PetsView: _refreshPetList called'); // 클래스 이름 변경
    // controller 대신 ref.read 로 Notifier 직접 호출
    ref.read(petProvider.notifier).getPetList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 의존성 변경 시 (예: 화면 첫 로드 시) 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshPetList();
    });
  }

  @override
  bool get wantKeepAlive => true; // 탭 전환 시 상태 유지

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요
    final petState = ref.watch(petProvider);
    final pets = petState.pets;

    return SafeArea(
      child: Column(
        children: [
          // 새로고침 버튼 추가
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // controller 대신 ref.read 로 Notifier 직접 호출
                    ref.read(petProvider.notifier).getPetList();
                    // 새로고침 피드백
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('반려동물 목록을 새로고침했습니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: '새로고침',
                ),
              ],
            ),
          ),
          Expanded(
            child:
                petState.isLoading
                    // 로딩 중
                    ? const Center(child: CircularProgressIndicator())
                    // 반려동물이 없을 때
                    : pets.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: AddPetButton(onTap: _navigateToPetRegister),
                      ),
                    )
                    // 반려동물이 있을 때
                    : Column(
                      children: [
                        Expanded(
                          child: PetCarousel(
                            pets: pets,
                            onPetTap: (pet) => _onPetTap(context, pet),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: AddPetButtonCircle(
                            onTap: _navigateToPetRegister,
                          ),
                        ),
                      ],
                    ),
          ),
          QrScanCard(
            onTap: () {
              // context.pushNamed('qr_scanner'); // 이름 있는 라우트 사용 시
              context.push('/qr-scanner'); // 경로 직접 사용 시
            },
          ),
        ],
      ),
    );
  }
}

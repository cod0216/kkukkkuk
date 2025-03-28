import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/controllers/pet_controller.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/providers/pet/pet_provider.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/add_pet_button.dart';
import 'package:kkuk_kkuk/screens/common/widgets/add_circle_icon.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/pet_carousel.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/qr_scan_button.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsScreenState();
}

class _PetsScreenState extends ConsumerState<PetsView>
    with AutomaticKeepAliveClientMixin {
  late final PetController _controller;

  void _navigateToPetRegister() {
    context.push('/pet-register').then((_) {
      // 펫 등록 화면에서 돌아왔을 때
      print('PetsScreen: _navigateToPetRegister');
      _refreshPetList();
    });
  }

  void _onPetTap(BuildContext context, Pet pet) {
    context.push('/pet-detail', extra: pet).then((_) {
      // 펫 상세 화면에서 돌아왔을 때
      print('PetsScreen: _onPetTap');
      _refreshPetList();
    });
  }

  void _refreshPetList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('PetsScreen: _refreshPetList');
      _controller.getPetList();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ref.read(petControllerProvider);
    // 반려동물 목록 가져오기
    _refreshPetList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 다른 화면에서 돌아올 때
    print('PetsScreen: didChangeDependencies');
    _refreshPetList();
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
                    _controller.getPetList();
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
              // TODO: QR 스캔 페이지
            },
          ),
        ],
      ),
    );
  }
}

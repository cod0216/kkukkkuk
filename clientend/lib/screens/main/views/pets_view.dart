import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/controllers/pet_controller.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/providers/main/pet_provider.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/add_pet_button.dart';
import 'package:kkuk_kkuk/screens/common/widgets/add_circle_icon.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/pet_carousel.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/qr_scan_button.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsScreenState();
}

class _PetsScreenState extends ConsumerState<PetsView> {
  late final PetController _controller;

  void _navigateToPetRegister() {
    context.push('/pet-register');
  }

  void _onPetTap(BuildContext context, Pet pet) {
    context.push('/pet-detail', extra: pet);
  }

  @override
  void initState() {
    super.initState();
    _controller = ref.read(petControllerProvider);
    // 반려동물 목록 가져오기
    Future.microtask(() => _controller.getPetList());
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petProvider);
    final pets = petState.pets;

    return SafeArea(
      child: Column(
        children: [
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

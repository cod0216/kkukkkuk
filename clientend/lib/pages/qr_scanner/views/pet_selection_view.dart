import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_provider.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/card/pet_card.dart';
import 'package:kkuk_kkuk/pages/common/widgets/loading_indicator.dart';

class PetSelectionView extends ConsumerStatefulWidget {
  final HospitalQRData hospitalData;

  const PetSelectionView({super.key, required this.hospitalData});

  @override
  ConsumerState<PetSelectionView> createState() => _PetSelectionViewState();
}

class _PetSelectionViewState extends ConsumerState<PetSelectionView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Schedule the provider update after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPets();
    });
  }

  void _loadPets() {
    final petState = ref.read(petProvider);
    if (petState.pets.isEmpty && !petState.isLoading && !_isInitialized) {
      _isInitialized = true;
      ref.read(petProvider.notifier).getPetList();
    }
  }

  void _selectPet(Pet pet) {
    context.push(
      '/qr-scanner/sharing-result',
      extra: {'pet': pet, 'hospital': widget.hospitalData},
    );
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('반려동물 선택')),
      body:
          petState.isLoading
              ? const LoadingIndicator(message: '반려동물 목록을 불러오는 중입니다')
              : petState.error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('오류: ${petState.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _isInitialized = false;
                        _loadPets();
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              )
              : petState.pets.isEmpty
              ? const Center(child: Text('등록된 반려동물이 없습니다.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: petState.pets.length,
                itemBuilder: (context, index) {
                  final pet = petState.pets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    // Fix: Update the onTap callback to match the expected signature
                    child: PetCard(pet: pet, onTap: _selectPet),
                  );
                },
              ),
    );
  }
}

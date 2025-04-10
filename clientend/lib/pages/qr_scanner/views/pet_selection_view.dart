import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/pages/main/notifiers/pet_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart'; // CustomHeader 추가
import 'package:kkuk_kkuk/widgets/pet/card/pet_card.dart';
import 'package:kkuk_kkuk/widgets/common/loading_indicator.dart';
import 'package:kkuk_kkuk/widgets/common/error_view.dart'; // ErrorView 추가

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPets();
    });
  }

  void _loadPets() {
    final petState = ref.read(petNotifierProvider);
    if (petState.pets.isEmpty && !petState.isLoading && !_isInitialized) {
      _isInitialized = true;
      ref.read(petNotifierProvider.notifier).getPetList();
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
    final petState = ref.watch(petNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        // SafeArea 추가
        child: Column(
          // Column으로 감싸서 Header 추가
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              // Header에 패딩 적용
              padding: EdgeInsets.all(16.0),
              child: CustomHeader(
                title: '반려동물 선택',
                subtitle: '병원에 의료 기록 접근 권한을 부여할\n반려동물을 선택해주세요.',
              ),
            ),
            // 기존 로직을 Expanded로 감싸서 남은 공간 차지
            Expanded(
              child:
                  petState.isLoading
                      ? const Center(
                        child: LoadingIndicator(message: '반려동물 목록 로딩 중...'),
                      ) // Center 정렬 및 메시지 변경
                      : petState.error != null
                      ? Center(
                        // ErrorView 사용
                        child: ErrorView(
                          message: petState.error!,
                          onRetry: () {
                            _isInitialized = false;
                            _loadPets();
                          },
                        ),
                      )
                      : petState.pets.isEmpty
                      ? const Center(
                        child: Text('등록된 반려동물이 없습니다.'),
                      ) // 스타일 적용 가능
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ), // 패딩 조정
                        itemCount: petState.pets.length,
                        itemBuilder: (context, index) {
                          final pet = petState.pets[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            // SizedBox 높이 고정 제거, AspectRatio 사용 또는 PetCard 내부 크기 조정
                            child: AspectRatio(
                              // 예시: 16:9 비율 유지
                              aspectRatio: 16 / 10, // PetCard 비율에 맞게 조정
                              child: PetCard(pet: pet, onTap: _selectPet),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

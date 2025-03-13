import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/medical_record_query_controller.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/providers/medical_record/medical_record_query_provider.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/empty_medical_records.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/medical_record_card.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/pet_profile_header.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/last_treatment_date.dart';

/// 반려동물 프로필 화면
class PetProfileScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  ConsumerState<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  late final MedicalRecordQueryController _controller;

  // TODO: 화면 새로고침 기능 추가
  // TODO: 진료 기록 정렬 기능 추가 (최신순/과거순)
  // TODO: 진료 기록 필터링 기능 추가 (진료 유형별)
  // TODO: 진료 기록 검색 기능 추가
  // TODO: 진료 기록 공유 기능 추가
  // TODO: 블록체인 데이터 검증 기능 추가

  @override
  void initState() {
    super.initState();
    _controller = ref.read(medicalRecordQueryControllerProvider);
    _loadMedicalRecords();
  }

  /// 진료 기록 데이터 로드
  void _loadMedicalRecords() {
    // TODO: 로딩 상태 표시 개선
    // TODO: 에러 처리 및 재시도 기능 추가
    // TODO: 페이지네이션 구현
    Future.microtask(() => _controller.getAllRecords(widget.pet.id ?? 1));
  }

  @override
  Widget build(BuildContext context) {
    final medicalRecordState = ref.watch(medicalRecordQueryProvider);
    final records = medicalRecordState.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('반려동물 프로필'),
        // TODO: 프로필 편집 버튼 추가
        // TODO: 설정 메뉴 추가
        // TODO: 공유 버튼 추가
      ),
      body: Column(
        children: [
          // 반려동물 기본 정보 헤더
          PetProfileHeader(pet: widget.pet),

          // 최근 진료일 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LastTreatmentDate(records: records),
          ),

          // 진료 기록 목록
          Expanded(
            child:
                medicalRecordState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : records.isEmpty
                    ? const EmptyRecords()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: records.length,
                      // TODO: 무한 스크롤 구현
                      // TODO: 스크롤 위치 저장 및 복원
                      // TODO: 진료 기록 카드 애니메이션 효과 추가
                      itemBuilder: (context, index) {
                        return MedicalRecordCard(record: records[index]);
                      },
                    ),
          ),
        ],
      ),
      // TODO: FAB 추가 (새로운 진료 기록 추가)
      // TODO: 하단 네비게이션 바 추가 (필요한 경우)
    );
  }
}

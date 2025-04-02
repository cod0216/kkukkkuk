import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/medical_record_query_controller.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/get_all_attributes_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_provider.dart';
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
  late final GetAllAtributesUseCase _getMedicalRecordsFromBlockchainUseCase;

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
    _getMedicalRecordsFromBlockchainUseCase = ref.read(
      getAllAtributesUseCaseProvider,
    );
    _loadMedicalRecords();
  }

  /// 진료 기록 데이터 로드
  @override
  void dispose() {
    // 화면이 종료될 때 진료 기록 상태 초기화
    Future.microtask(() {
      _controller.clearRecords();
    });
    super.dispose();
  }

  void _loadMedicalRecords() {
    // 진료 기록 상태 초기화 후 새로운 데이터 로드
    Future.microtask(() {
      _controller.clearRecords();
    });
    // 기존 DB에서 진료 기록 조회
    Future.microtask(() async {
      // await _controller.getAllRecords(1);

      // DB 조회 후 블록체인 데이터 조회
      if (widget.pet.did != null && widget.pet.did!.isNotEmpty) {
        await _loadMedicalRecordsFromBlockchain(widget.pet.did!);
      }
    });
  }

  /// 블록체인에서 진료 기록 데이터 로드
  Future<void> _loadMedicalRecordsFromBlockchain(String petAddress) async {
    try {
      // 블록체인에서 진료 기록 조회
      final records = await _getMedicalRecordsFromBlockchainUseCase.execute(
        petAddress,
      );

      if (!mounted) return;

      if (records.isNotEmpty) {
        // 상태 업데이트 전에 현재 상태 확인
        print(
          '현재 상태의 레코드 수: ${ref.read(medicalRecordQueryProvider).records.length}',
        );

        // 블록체인에서 조회한 진료 기록을 상태에 추가
        ref
            .read(medicalRecordQueryProvider.notifier)
            .addBlockchainRecords(records);
      }
    } catch (e) {
      print('블록체인에서 진료 기록 조회 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('블록체인 데이터 조회 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 상태 변화를 감지하기 위해 watch 사용
    final medicalRecordState = ref.watch(medicalRecordQueryProvider);
    final records = medicalRecordState.records;

    print('빌드 시 레코드 수: ${records.length}');
    print('레코드 내용: $records');

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

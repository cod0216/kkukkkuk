import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/ocr/ocr_service.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/pages/pet_profile/notifiers/pet_medical_record_notifier.dart'; // Notifier import
import 'package:kkuk_kkuk/pages/pet_profile/notifiers/pet_medical_record_register_notifier.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';
import 'package:kkuk_kkuk/widgets/common/loading_indicator.dart'; // LoadingIndicator import
import 'package:kkuk_kkuk/widgets/common/error_view.dart';
import 'package:kkuk_kkuk/widgets/common/primary_section.dart';
import 'package:kkuk_kkuk/widgets/controller/refresh_controller.dart';
import 'package:kkuk_kkuk/widgets/pet/profile/empty_medical_records.dart';
import 'package:kkuk_kkuk/widgets/pet/profile/medical_record_card.dart';
import 'package:kkuk_kkuk/widgets/pet/profile/medical_record_image_picker.dart';
import 'package:kkuk_kkuk/widgets/pet/profile/pet_profile_header.dart'; // ErrorView import

class PetProfileScreen extends ConsumerStatefulWidget {
  final Pet pet;
  const PetProfileScreen({super.key, required this.pet});

  @override
  ConsumerState<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMedicalRecords();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicalRecords() async {
    final petDid = widget.pet.did;
    if (petDid != null && petDid.isNotEmpty) {
      await ref
          .read(medicalRecordQueryProvider.notifier)
          .loadLatestRecords(petDid);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('반려동물 정보(DID)가 없어 진료 기록을 조회할 수 없습니다.')),
        );
      }
    }
  }

  // 새로고침 처리 함수 (Notifier 호출)
  Future<void> _onRefresh() async {
    try {
      await _loadMedicalRecords(); // Notifier의 로딩 함수 재호출
      _refreshController.refreshCompleted();
    } catch (e) {
      // UseCase에서 던진 에러를 잡을 수 있음 (Notifier에서 rethrow한 경우)
      _refreshController.refreshFailed();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('새로고침 중 오류 발생: $e')));
      }
    }
  }

  final OcrService _ocrService = OcrService(); // OCR 서비스

  // 이미지 선택 및 처리 핸들러
  Future<void> _handleImageSelected(File image) async {
    // 로딩 다이얼로그 표시 (OCR 및 등록 처리 중)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const PopScope(
            // Android 뒤로가기 방지
            canPop: false,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('진료기록 처리 중...'),
                ],
              ),
            ),
          ),
    );

    try {
      // 1. OCR 처리
      final ocrData = await _ocrService.processImage(image);

      // 2. OCR 결과 서버 전송 및 데이터 정제
      final processedData = await ref
          .read(processMedicalRecordImageUseCaseProvider)
          .execute(ocrData);

      if (!mounted) return;
      Navigator.of(context).pop(); // OCR/처리 로딩 다이얼로그 닫기

      // 3. 사용자 확인 다이얼로그
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('진료기록 확인'),
              // ... (기존 확인 다이얼로그 내용) ...
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    // 이미지 피커 다시 표시
                    final imagePicker = MedicalRecordImagePicker(
                      context: context,
                      onImageSelected: _handleImageSelected,
                    );
                    imagePicker.showImageSourceDialog();
                  },
                  child: const Text('다시 선택'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('등록하기'),
                ),
              ],
            ),
      );

      if (confirmed != true) return; // 사용자가 취소

      if (!mounted) return;
      // 등록 로딩 다이얼로그 다시 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const PopScope(
              canPop: false,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('블록체인에 등록 중...\n잠시만 기다려주세요.'),
                  ],
                ),
              ),
            ),
      );

      // 4. 블록체인 등록
      await ref
          .read(medicalRecordRegisterProvider.notifier)
          .registerMedicalRecord(widget.pet.did!, processedData);

      if (!mounted) return;
      Navigator.of(context).pop(); // 등록 로딩 다이얼로그 닫기

      // 5. 성공 알림 및 목록 새로고침
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('진료기록이 성공적으로 등록되었습니다.')));
      _loadMedicalRecords(); // 목록 새로고침
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('진료기록 처리/등록 중 오류: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicalRecordState = ref.watch(medicalRecordQueryProvider);
    final records = medicalRecordState.records;
    final isLoading = medicalRecordState.isLoading;
    final error = medicalRecordState.error;
    final registerState = ref.watch(medicalRecordRegisterProvider);

    // 최근 진료일 찾기 (여기서 계산 또는 LastTreatmentDate 위젯 내부에서 처리)
    MedicalRecord? latestRecord;
    if (records.isNotEmpty) {
      latestRecord = records.reduce(
        (a, b) => a.treatmentDate.isAfter(b.treatmentDate) ? a : b,
      );
    }
    final formattedLatestDate =
        latestRecord != null
            ? DateFormat('yyyy년 MM월 dd일').format(latestRecord.treatmentDate)
            : '진료 기록 없음';

    return Scaffold(
      appBar: CustomAppBar(), // 기존 AppBar 유지
      body: RefreshIndicator(
        // RefreshIndicator 추가
        onRefresh: _onRefresh,
        child: CustomScrollView(
          // 스크롤 가능한 영역 구성
          slivers: [
            // 1. 펫 프로필 헤더
            SliverToBoxAdapter(child: PetProfileHeader(pet: widget.pet)),
            // 2. "진료 기록" 제목 및 최근 진료일 (PrimarySection 활용)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ), // 패딩 조정
              sliver: SliverToBoxAdapter(
                child: PrimarySection(
                  // PrimarySection 사용
                  title: '진료 기록',
                  spacing: 4, // 제목과 내용 간격 조정
                  child: Text(
                    '최근 진료: $formattedLatestDate',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              ),
            ),
            // 3. 진료 기록 목록 또는 상태 표시
            _buildMedicalRecord(isLoading, error, records),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // FAB 스타일은 유지
        onPressed:
            registerState.isLoading
                ? null
                : () {
                  if (widget.pet.did == null || widget.pet.did!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('반려동물 정보(DID)가 없습니다.')),
                    );
                    return;
                  }
                  final imagePicker = MedicalRecordImagePicker(
                    context: context,
                    onImageSelected: _handleImageSelected,
                  );
                  imagePicker.showImageSourceDialog();
                },
        tooltip: '진료기록 추가',
        child:
            registerState.isLoading
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )
                : const Icon(Icons.add_photo_alternate_outlined),
      ),
    );
  }

  Widget _buildMedicalRecord(
    bool isLoading,
    String? error,
    List<MedicalRecord> records,
  ) {
    // 초기 로딩 상태
    if (isLoading && records.isEmpty) {
      return const SliverFillRemaining(
        // 남은 공간 채우도록 변경
        child: Center(child: LoadingIndicator(message: '진료 기록을 불러오는 중...')),
      );
    }
    // 에러 상태
    if (error != null) {
      return SliverFillRemaining(
        child: Center(
          child: ErrorView(message: error, onRetry: _loadMedicalRecords),
        ),
      );
    }
    // 로딩 완료 후 데이터 없음
    if (records.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyRecords(), // 데이터 없음 표시 위젯
      );
    }
    // 데이터 있음 (SliverList 사용)
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 80,
      ), // FAB 공간 확보 및 좌우 패딩
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return MedicalRecordCard(record: records[index]); // 스타일 수정된 카드 사용
        }, childCount: records.length),
      ),
    );
  }
}

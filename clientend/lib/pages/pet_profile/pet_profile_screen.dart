import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/model/get_all_attributes_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/features/pet/notifiers/pet_medical_record_notifier.dart';
import 'package:kkuk_kkuk/features/pet/notifiers/pet_medical_record_register_provider.dart';
import 'package:kkuk_kkuk/pages/pet_profile/widgets/empty_medical_records.dart';
import 'package:kkuk_kkuk/pages/pet_profile/widgets/medical_record_card.dart';
import 'package:kkuk_kkuk/pages/pet_profile/widgets/pet_profile_header.dart';
import 'package:kkuk_kkuk/pages/pet_profile/widgets/last_treatment_date.dart';
import 'package:kkuk_kkuk/pages/pet_profile/widgets/medical_record_image_picker.dart';
import 'package:kkuk_kkuk/features/ocr/ocr_service.dart';

class PetProfileScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  ConsumerState<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  late final GetAllAtributesUseCase _getMedicalRecordsFromBlockchainUseCase;

  // TODO: 화면 새로고침 기능 추가 (진료기록을 아래로 스크롤하면 새로 로드)
  // TODO: 진료 기록 정렬 기능 추가 (최신순/과거순)
  // TODO: 진료 기록 필터링 기능 추가 (진료 유형별)
  // TODO: 진료 기록 검색 기능 추가

  // 새로고침 컨트롤러 추가
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _getMedicalRecordsFromBlockchainUseCase = ref.read(
      getAllAtributesUseCaseProvider,
    );
    _loadMedicalRecords();
  }

  @override
  void dispose() {
    // 화면이 종료될 때 진료 기록 상태 초기화
    Future.microtask(() {
      ref.read(medicalRecordQueryProvider.notifier).clearRecords();
    });
    _refreshController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 새로고침 처리 함수
  Future<void> _onRefresh() async {
    try {
      // 진료 기록 상태 초기화
      ref.read(medicalRecordQueryProvider.notifier).clearRecords();

      // 블록체인에서 데이터 다시 로드
      if (widget.pet.did != null && widget.pet.did!.isNotEmpty) {
        await _loadMedicalRecordsFromBlockchain(widget.pet.did!);
      }

      // 새로고침 완료
      _refreshController.refreshCompleted();
    } catch (e) {
      // 새로고침 실패
      _refreshController.refreshFailed();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('새로고침 실패: $e')));
      }
    }
  }

  /// 진료 기록 데이터 로드
  void _loadMedicalRecords() {
    // 진료 기록 상태 초기화 후 새로운 데이터 로드
    Future.microtask(() {
      ref.read(medicalRecordQueryProvider.notifier).clearRecords();
    });
    // 기존 DB에서 진료 기록 조회
    Future.microtask(() async {
      // DB 조회 후 블록체인 데이터 조회
      if (widget.pet.did != null && widget.pet.did!.isNotEmpty) {
        await _loadMedicalRecordsFromBlockchain(widget.pet.did!);
      }
    });
  }

  /// 블록체인에서 진료 기록 데이터 로드
  Future<void> _loadMedicalRecordsFromBlockchain(String petAddress) async {
    try {
      final records = await _getMedicalRecordsFromBlockchainUseCase.execute(
        petAddress,
      );

      if (!mounted) return;

      if (records.isNotEmpty) {
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

  final OcrService _ocrService = OcrService();

  Future<void> _handleImageSelected(File image) async {
    try {
      // Show OCR processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => WillPopScope(
              onWillPop: () async => false,
              child: const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('진료기록을 분석하는 중입니다...\n잠시만 기다려주세요.'),
                  ],
                ),
              ),
            ),
      );

      // Process image with OCR
      final ocrData = await _ocrService.processImage(image);

      // Process OCR data with server
      final processedData = await ref
          .read(processMedicalRecordImageUseCaseProvider)
          .execute(ocrData);

      if (!mounted) return;
      Navigator.of(context).pop(); // Close processing dialog

      // Show confirmation dialog with processed data
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('진료기록 확인'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('아래 내용이 맞는지 확인해주세요:'),
                    const SizedBox(height: 16),
                    Text('진단명: ${processedData['diagnosis']}'),
                    Text('수의사: ${processedData['doctorName']}'),
                    Text('병원명: ${processedData['hospitalName']}'),
                    Text('메모: ${processedData['notes']}'),
                    const SizedBox(height: 8),
                    const Text('검사 항목:'),
                    ...processedData['examinations'].map<Widget>(
                      (e) => Text('- ${e['key']}: ${e['value']}'),
                    ),
                    const SizedBox(height: 8),
                    const Text('처방 약물:'),
                    ...processedData['medications'].map<Widget>(
                      (e) => Text('- ${e['key']}: ${e['value']}'),
                    ),
                    const SizedBox(height: 8),
                    const Text('접종 정보:'),
                    ...processedData['vaccinations'].map<Widget>(
                      (e) => Text('- ${e['key']}: ${e['value']}'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    // Show image picker again
                    final imagePicker = MedicalRecordImagePicker(
                      context: context,
                      onImageSelected: _handleImageSelected,
                    );
                    imagePicker.showImageSourceDialog();
                  },
                  child: const Text('다시 시도'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('확인'),
                ),
              ],
            ),
      );

      if (confirmed != true) return;

      // Show registration dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => WillPopScope(
              onWillPop: () async => false,
              child: const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('진료기록을 등록하는 중입니다...\n잠시만 기다려주세요.'),
                  ],
                ),
              ),
            ),
      );

      // TODO: transaction 완료까지 대기
      await ref
          .read(medicalRecordRegisterProvider.notifier)
          .registerMedicalRecord(widget.pet.did!, processedData);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('진료기록이 등록되었습니다.')));

      // Refresh medical records
      _loadMedicalRecords();
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('진료기록 처리 중 오류가 발생했습니다: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicalRecordState = ref.watch(medicalRecordQueryProvider);
    final records = medicalRecordState.records;
    final registerState = ref.watch(medicalRecordRegisterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('반려동물 프로필')),
      body: Column(
        children: [
          PetProfileHeader(pet: widget.pet),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LastTreatmentDate(records: records),
          ),
          Expanded(
            child:
                medicalRecordState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : records.isEmpty
                    ? const EmptyRecords()
                    : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return MedicalRecordCard(record: records[index]);
                        },
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            registerState.isLoading
                ? null
                : () async {
                  if (widget.pet.did == null || widget.pet.did!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('반려동물 DID가 없습니다.')),
                    );
                    return;
                  }

                  // Use the new image picker
                  final imagePicker = MedicalRecordImagePicker(
                    context: context,
                    onImageSelected: _handleImageSelected,
                  );
                  imagePicker.showImageSourceDialog();
                },
        child:
            registerState.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.add),
      ),
    );
  }
}

// RefreshController 클래스 추가
class RefreshController {
  VoidCallback? _onRefreshCompleted;
  VoidCallback? _onRefreshFailed;

  void refreshCompleted() {
    if (_onRefreshCompleted != null) {
      _onRefreshCompleted!();
    }
  }

  void refreshFailed() {
    if (_onRefreshFailed != null) {
      _onRefreshFailed!();
    }
  }

  void dispose() {
    _onRefreshCompleted = null;
    _onRefreshFailed = null;
  }
}

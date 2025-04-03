import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/medical_record_query_controller.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/get_all_attributes_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_provider.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_register_provider.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/empty_medical_records.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/medical_record_card.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/pet_profile_header.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/last_treatment_date.dart';
import 'package:kkuk_kkuk/screens/pet_profile/widgets/medical_record_image_picker.dart';
import 'package:kkuk_kkuk/services/ocr_service.dart';

class PetProfileScreen extends ConsumerStatefulWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  ConsumerState<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  late final MedicalRecordQueryController _controller;
  late final GetAllAtributesUseCase _getMedicalRecordsFromBlockchainUseCase;

  // TODO: 화면 새로고침 기능 추가 (진료기록을 아래로 스크롤하면 새로 로드)
  // TODO: 진료 기록 정렬 기능 추가 (최신순/과거순)
  // TODO: 진료 기록 필터링 기능 추가 (진료 유형별)
  // TODO: 진료 기록 검색 기능 추가

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
      // Show loading dialog
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
      Navigator.of(context).pop();

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

      // Register medical record with processed data
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
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        return MedicalRecordCard(record: records[index]);
                      },
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

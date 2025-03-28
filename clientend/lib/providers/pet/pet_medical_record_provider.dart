import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/get_medical_records_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/get_medical_records_by_date_range_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/pet_medical_record_usecase_providers.dart';

/// 진료 기록 조회 상태 관리 클래스
class MedicalRecordQueryState {
  final List<PetMedicalRecord> records; // 진료 기록 목록
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지
  final DateTime? lastQueryDate; // 마지막 조회 일시

  MedicalRecordQueryState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    this.lastQueryDate,
  });

  // TODO: 진료 기록 정렬 기능 추가 (날짜순, 진료유형별 등)
  // TODO: 진료 기록 필터링 기능 추가 (기간별, 진료유형별 등)
  // TODO: 진료 기록 검색 기능 추가 (키워드 검색)

  /// 상태 복사 메서드
  MedicalRecordQueryState copyWith({
    List<PetMedicalRecord>? records,
    bool? isLoading,
    String? error,
    DateTime? lastQueryDate,
  }) {
    return MedicalRecordQueryState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastQueryDate: lastQueryDate ?? this.lastQueryDate,
    );
  }
}

/// 진료 기록 조회 상태 관리 노티파이어
class MedicalRecordQueryNotifier
    extends StateNotifier<MedicalRecordQueryState> {
  final GetMedicalRecordsUseCase _getMedicalRecordsUseCase;
  final GetMedicalRecordsByDateRangeUseCase
  _getMedicalRecordsByDateRangeUseCase;

  MedicalRecordQueryNotifier(
    this._getMedicalRecordsUseCase,
    this._getMedicalRecordsByDateRangeUseCase,
  ) : super(MedicalRecordQueryState());

  /// 전체 진료 기록 조회
  Future<void> getMedicalRecords(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await _getMedicalRecordsUseCase.execute(petId);
      // Keep existing blockchain records when updating from API
      final allRecords = [...state.records, ...records];
      state = state.copyWith(
        records: allRecords,
        isLoading: false,
        lastQueryDate: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '진료 기록을 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 블록체인에서 조회한 진료 기록 추가
  void addBlockchainRecords(List<PetMedicalRecord> blockchainRecords) {
    if (blockchainRecords.isEmpty) return;

    print('Adding blockchain records: $blockchainRecords');
    print('Current state records: ${state.records}');

    // Preserve existing records and add new ones
    final allRecords = [...state.records, ...blockchainRecords];

    // Remove duplicates based on treatment date and details
    final uniqueRecords = <PetMedicalRecord>[];
    final recordKeys = <String>{};

    for (final record in allRecords) {
      final key =
          '${record.treatmentDate.toIso8601String()}_${record.treatmentDetails}';

      if (!recordKeys.contains(key)) {
        recordKeys.add(key);
        uniqueRecords.add(record);
      }
    }

    // Sort by date (descending)
    uniqueRecords.sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));

    print('Final unique records count: ${uniqueRecords.length}');

    // Update state while preserving other fields
    state = state.copyWith(
      records: uniqueRecords,
      lastQueryDate: DateTime.now(),
      isLoading: false, // Ensure loading is false
    );

    // Verify state update
    print('State updated - record count: ${state.records.length}');
  }
}

/// 진료 기록 조회 프로바이더
final medicalRecordQueryProvider = StateNotifierProvider<
  MedicalRecordQueryNotifier,
  MedicalRecordQueryState
>((ref) {
  final getMedicalRecordsUseCase = ref.watch(getMedicalRecordsUseCaseProvider);
  final getMedicalRecordsByDateRangeUseCase = ref.watch(
    getMedicalRecordsByDateRangeUseCaseProvider,
  );

  return MedicalRecordQueryNotifier(
    getMedicalRecordsUseCase,
    getMedicalRecordsByDateRangeUseCase,
  );
});

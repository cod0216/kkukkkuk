import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';

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
  MedicalRecordQueryNotifier() : super(MedicalRecordQueryState());

  /// 진료 기록 상태 초기화
  void clearRecords() {
    state = MedicalRecordQueryState();
  }

  /// 블록체인에서 조회한 진료 기록 추가
  void addBlockchainRecords(List<PetMedicalRecord> blockchainRecords) {
    if (blockchainRecords.isEmpty) return;

    final allRecords = [...state.records, ...blockchainRecords];

    // Remove duplicates based on treatment date and diagnosis
    final uniqueRecords = <PetMedicalRecord>[];
    final recordKeys = <String>{};

    for (final record in allRecords) {
      final key = record.treatmentDate.toIso8601String();

      if (!recordKeys.contains(key)) {
        recordKeys.add(key);
        uniqueRecords.add(record);
      }
    }

    // Sort by date (descending)
    uniqueRecords.sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));

    state = state.copyWith(
      records: uniqueRecords,
      lastQueryDate: DateTime.now(),
      isLoading: false,
    );
  }
}

/// 진료 기록 조회 프로바이더
final medicalRecordQueryProvider =
    StateNotifierProvider<MedicalRecordQueryNotifier, MedicalRecordQueryState>((
      ref,
    ) {
      return MedicalRecordQueryNotifier();
    });

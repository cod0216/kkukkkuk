import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/pages/pet_profile/states/medical_record_query_state.dart';

/// 진료 기록 조회 상태 관리 노티파이어
class MedicalRecordQueryNotifier
    extends StateNotifier<MedicalRecordQueryState> {
  final Ref ref;

  MedicalRecordQueryNotifier(this.ref) : super(MedicalRecordQueryState());

  /// 진료 기록 상태 초기화
  void clearRecords() {
    state = MedicalRecordQueryState();
  }

  /// 블록체인에서 조회한 진료 기록 추가
  void addBlockchainRecords(List<MedicalRecord> blockchainRecords) {
    if (blockchainRecords.isEmpty) return;

    // TODO: hash[medicalKey] = set<medical> 2차원구조로 최신 데이터를 가져올수있도록함
    final allRecords = [...state.records, ...blockchainRecords];

    // Remove duplicates based on treatment date and diagnosis
    final uniqueRecords = <MedicalRecord>[];
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
      records: allRecords,
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
      return MedicalRecordQueryNotifier(ref);
    });

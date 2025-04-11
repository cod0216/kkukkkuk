import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';

/// 진료 기록 조회 상태 관리 클래스
class MedicalRecordQueryState {
  final List<MedicalRecord> records; // 진료 기록 목록
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지
  final DateTime? lastQueryDate; // 마지막 조회 일시

  MedicalRecordQueryState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    this.lastQueryDate,
  });

  /// 상태 복사 메서드
  MedicalRecordQueryState copyWith({
    List<MedicalRecord>? records,
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

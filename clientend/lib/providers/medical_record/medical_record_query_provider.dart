import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/services/pet_medical_block_chain_service.dart';

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
  final PetMedicalBlockChainService _service;

  MedicalRecordQueryNotifier(this._service) : super(MedicalRecordQueryState());

  /// 전체 진료 기록 조회
  Future<void> getMedicalRecords(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 블록체인 데이터 캐싱 구현
      // TODO: 페이지네이션 구현
      // TODO: 데이터 정렬 로직 구현
      final records = await _service.getMedicalRecords(petId);
      state = state.copyWith(
        records: records,
        isLoading: false,
        lastQueryDate: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '진료 기록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 기간별 진료 기록 조회
  Future<void> getRecordsByDateRange(
    int petId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 날짜 범위 유효성 검사 추가
      // TODO: 날짜 기준 정렬 로직 구현
      // TODO: 기간별 데이터 캐싱 구현
      final records = await _service.getMedicalRecordsByDateRange(
        petId,
        startDate,
        endDate,
      );
      state = state.copyWith(
        records: records,
        isLoading: false,
        lastQueryDate: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '기간별 진료 기록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 상태 초기화
  void resetState() {
    // TODO: 캐시 데이터 삭제 구현
    // TODO: 리소스 정리 로직 추가
    state = MedicalRecordQueryState();
  }
}

/// 진료 기록 조회 프로바이더
final medicalRecordQueryProvider =
    StateNotifierProvider<MedicalRecordQueryNotifier, MedicalRecordQueryState>((
      ref,
    ) {
      final service = ref.watch(petMedicalRecordServiceProvider);
      return MedicalRecordQueryNotifier(service);
    });

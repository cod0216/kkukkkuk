import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_medical_record.dart';
import 'package:kkuk_kkuk/services/pet_medical_block_chain_service.dart';

/// 반려동물 진료 기록 상태 관리 클래스
class PetMedicalRecordState {
  final List<PetMedicalRecord> records; // 진료 기록 목록
  final bool isLoading; // 로딩 상태
  final String? error; // 에러 메시지

  // TODO: 진료 기록 정렬 기능 추가
  // TODO: 진료 기록 필터링 기능 추가
  // TODO: 진료 기록 검색 기능 추가
  // TODO: 진료 기록 캐싱 구현
  // TODO: 페이지네이션 구현

  PetMedicalRecordState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  /// 상태 복사 메서드
  PetMedicalRecordState copyWith({
    List<PetMedicalRecord>? records,
    bool? isLoading,
    String? error,
  }) {
    return PetMedicalRecordState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 반려동물 진료 기록 상태 관리 노티파이어
class PetMedicalRecordNotifier extends StateNotifier<PetMedicalRecordState> {
  final PetMedicalBlockChainService _service;

  PetMedicalRecordNotifier(this._service) : super(PetMedicalRecordState());

  /// 진료 기록 목록 조회
  Future<void> getMedicalRecords(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await _service.getMedicalRecords(petId);
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '진료 기록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 진료 기록 초기화
  void resetRecords() {
    state = PetMedicalRecordState();
  }
}

/// 반려동물 진료 기록 프로바이더
final petMedicalRecordProvider =
    StateNotifierProvider<PetMedicalRecordNotifier, PetMedicalRecordState>((
      ref,
    ) {
      final service = ref.watch(petMedicalRecordServiceProvider);
      return PetMedicalRecordNotifier(service);
    });

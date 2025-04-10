import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/pages/pet_profile/states/medical_record_query_state.dart';

class MedicalRecordQueryNotifier
    extends StateNotifier<MedicalRecordQueryState> {
  final Ref ref;

  MedicalRecordQueryNotifier(this.ref) : super(MedicalRecordQueryState());

  /// 반려동물의 최신 진료 기록 로드
  Future<void> loadLatestRecords(String petDid) async {
    // 로딩 상태 시작 및 기존 데이터 초기화
    state = state.copyWith(isLoading: true, error: null, records: []);

    try {
      final records = await ref
          .read(loadMedicalRecordsUseCaseProvider)
          .execute(petDid);

      // 성공 시 상태 업데이트
      state = state.copyWith(
        records: records,
        isLoading: false,
        lastQueryDate: DateTime.now(),
        error: null, // 에러 상태 초기화
      );
    } catch (e) {
      print('진료 기록 로드 실패: $e');
      // 실패 시 상태 업데이트
      state = state.copyWith(
        isLoading: false,
        error: '진료 기록을 불러오는데 실패했습니다.', // 사용자 친화적 메시지
      );
      // 에러를 다시 던져서 UI에서 추가 처리 가능하도록 할 수도 있음
      // rethrow;
    }
  }
}

final medicalRecordQueryProvider =
    StateNotifierProvider<MedicalRecordQueryNotifier, MedicalRecordQueryState>(
      (ref) => MedicalRecordQueryNotifier(ref),
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_provider.dart';

/// 진료 기록 조회 전용 컨트롤러
class MedicalRecordQueryController {
  final Ref ref;

  MedicalRecordQueryController(this.ref);

  /// 전체 진료 기록 조회
  Future<void> getAllRecords(int petId) async {
    await ref
        .read(medicalRecordQueryProvider.notifier)
        .getMedicalRecords(petId);
  }

  /// 기간별 진료 기록 조회
  Future<void> getRecordsByDateRange(
    int petId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await null;
    // TODO: Implement getRecordsByDateRange method
    //ref.read(medicalRecordQueryProvider.notifier).getRecordsByDateRange(petId, startDate, endDate);
  }

  /// 현재 상태 조회
  MedicalRecordQueryState getState() {
    return ref.read(medicalRecordQueryProvider);
  }

  /// 로딩 상태 조회
  bool isLoading() {
    return ref.read(medicalRecordQueryProvider).isLoading;
  }

  /// 에러 상태 조회
  String? getError() {
    return ref.read(medicalRecordQueryProvider).error;
  }

  /// 진료 기록 상태 초기화
  void clearRecords() {
    ref.read(medicalRecordQueryProvider.notifier).clearRecords();
  }
}

final medicalRecordQueryControllerProvider =
    Provider<MedicalRecordQueryController>((ref) {
      return MedicalRecordQueryController(ref);
    });

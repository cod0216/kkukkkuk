// lib/features/pet/usecase/load_medical_records_usecase.dart
import 'dart:async'; // Future.wait 사용 위함
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_medical_record_with_updates_use_case.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_pet_original_records_use_case.dart';
import 'package:kkuk_kkuk/shared/utils/did_helper.dart';

class LoadMedicalRecordsUseCase {
  final GetPetOriginalRecordsUseCase _getPetOriginalRecordsUseCase;
  final GetMedicalRecordWithUpdatesUseCase _getMedicalRecordWithUpdatesUseCase;

  LoadMedicalRecordsUseCase(
    this._getPetOriginalRecordsUseCase,
    this._getMedicalRecordWithUpdatesUseCase,
  );

  Future<List<MedicalRecord>> execute(String petDid) async {
    try {
      final petAddress = DidHelper.extractAddressFromDid(petDid);
      final originRecordKeys = await _getPetOriginalRecordsUseCase.execute(
        petAddress,
      );

      if (originRecordKeys.isEmpty) {
        return [];
      }

      // 각 키에 대한 기록 조회 작업을 Future 리스트로 만듦
      final futures =
          originRecordKeys
              .map(
                (key) => _getMedicalRecordWithUpdatesUseCase.execute(
                  petAddress,
                  key,
                ),
              )
              .toList();

      // Future.wait를 사용하여 병렬로 실행하고 결과 받기
      final results = await Future.wait(futures);

      final List<MedicalRecord> latestRecords = [];
      for (final result in results) {
        final originalRecord = result['originalRecord'] as MedicalRecord?;
        final updateRecords =
            result['updateRecords'] as List<MedicalRecord>? ?? [];

        if (updateRecords.isNotEmpty) {
          // 업데이트 기록 중 가장 최신 것을 선택 (날짜 내림차순 정렬 후 첫 번째 요소)
          updateRecords.sort(
            (a, b) => b.treatmentDate.compareTo(a.treatmentDate),
          );
          latestRecords.add(updateRecords.first);
        } else if (originalRecord != null) {
          // 업데이트가 없으면 원본 기록 사용
          latestRecords.add(originalRecord);
        }
      }

      // 최종 목록을 날짜순으로 정렬 (최신순)
      latestRecords.sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));

      return latestRecords;
    } catch (e) {
      print('블록체인에서 진료 기록 조회 실패: $e');
      rethrow;
    }
  }
}

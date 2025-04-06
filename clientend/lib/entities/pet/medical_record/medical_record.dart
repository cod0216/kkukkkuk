import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/examination.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medication.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/vaccination.dart';

part 'medical_record.freezed.dart';

@freezed
abstract class MedicalRecord with _$MedicalRecord {
  const factory MedicalRecord({
    required DateTime treatmentDate,
    required String diagnosis,
    required String veterinarian,
    required String hospitalName,
    required String hospitalAddress,
    required List<Examination> examinations,
    required List<Medication> medications,
    required List<Vaccination> vaccinations,
    String? memo,
    required String status,
    required bool flagCertificated,
    @Default([]) List<String> pictures,
  }) = _MedicalRecord;
}

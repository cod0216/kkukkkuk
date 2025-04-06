import 'package:kkuk_kkuk/entities/medical_record/examination.dart';
import 'package:kkuk_kkuk/entities/medical_record/medication.dart';
import 'package:kkuk_kkuk/entities/medical_record/vaccination.dart';

class MedicalRecord {
  final DateTime treatmentDate;
  final String diagnosis;
  final String veterinarian;
  final String hospitalName;
  final String hospitalAddress;
  final List<Examination> examinations;
  final List<Medication> medications;
  final List<Vaccination> vaccinations;
  final String? memo;
  final String status;
  final bool flagCertificated;
  final List<String> pictures;

  MedicalRecord({
    required this.treatmentDate,
    required this.diagnosis,
    required this.veterinarian,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.examinations,
    required this.medications,
    required this.vaccinations,
    this.memo,
    required this.status,
    required this.flagCertificated,
    this.pictures = const [],
  });
}

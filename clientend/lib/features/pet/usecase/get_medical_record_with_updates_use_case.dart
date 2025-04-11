import 'dart:convert';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/examination.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medication.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/vaccination.dart';

class GetMedicalRecordWithUpdatesUseCase {
  final IPetRepository _repository;

  GetMedicalRecordWithUpdatesUseCase(this._repository);

  Future<Map<String, dynamic>> execute(
    String petAddress,
    String originalRecordKey,
  ) async {
    final rawData = await _repository.getMedicalRecordWithUpdates(
      petAddress,
      originalRecordKey,
    );

    // Convert the original record to MedicalRecord object
    MedicalRecord? originalRecord;
    if (rawData['originalRecord'] != null &&
        rawData['originalRecord'].isNotEmpty) {
      final originalRecordData = jsonDecode(rawData['originalRecord']);
      originalRecord = _convertToMedicalRecord(
        originalRecordData,
        originalRecordKey,
        isOriginal: true,
      );
    }

    // Convert update records to MedicalRecord objects
    final List<MedicalRecord> updateRecords = [];
    if (rawData['updateRecords'] != null) {
      for (int i = 0; i < rawData['updateRecords'].length; i++) {
        final String recordJson = rawData['updateRecords'][i];
        if (recordJson.isNotEmpty) {
          final recordData = jsonDecode(recordJson);
          final record = _convertToMedicalRecord(
            recordData,
            'update_${originalRecordKey}_$i',
            isOriginal: false,
            originalRecordKey: originalRecordKey,
          );
          if (record != null) {
            updateRecords.add(record);
          }
        }
      }
    }

    return {'originalRecord': originalRecord, 'updateRecords': updateRecords};
  }

  MedicalRecord? _convertToMedicalRecord(
    Map<String, dynamic> recordData,
    String recordKey, {
    bool isOriginal = false,
    String? originalRecordKey,
  }) {
    try {
      // Handle timestamp conversion
      int? timestampValue;
      if (recordData['createdAt'] != null) {
        timestampValue = recordData['createdAt'];
      } else if (recordData['timestamp'] != null) {
        timestampValue = int.tryParse(recordData['timestamp'].toString());
      }

      final treatmentDate =
          timestampValue != null
              ? DateTime.fromMillisecondsSinceEpoch(timestampValue * 1000)
              : DateTime.now();

      // Parse examinations
      final List<Examination> examinations = [];
      if (recordData['treatments']?['examinations'] != null) {
        for (final exam in recordData['treatments']['examinations']) {
          examinations.add(
            Examination(
              type: exam['type'] ?? '',
              key: exam['key'] ?? '',
              value: exam['value'] ?? '',
            ),
          );
        }
      }

      // Parse medications
      final List<Medication> medications = [];
      if (recordData['treatments']?['medications'] != null) {
        for (final med in recordData['treatments']['medications']) {
          medications.add(
            Medication(key: med['key'] ?? '', value: med['value'] ?? ''),
          );
        }
      }

      // Parse vaccinations
      final List<Vaccination> vaccinations = [];
      if (recordData['treatments']?['vaccinations'] != null) {
        for (final vac in recordData['treatments']['vaccinations']) {
          vaccinations.add(
            Vaccination(key: vac['key'] ?? '', value: vac['value'] ?? ''),
          );
        }
      }

      // Parse pictures
      List<String> pictures = [];
      if (recordData['pictures'] != null) {
        if (recordData['pictures'] is String) {
          try {
            pictures = List<String>.from(jsonDecode(recordData['pictures']));
          } catch (e) {
            pictures = [];
          }
        } else if (recordData['pictures'] is List) {
          pictures = List<String>.from(recordData['pictures']);
        }
      }

      return MedicalRecord(
        treatmentDate: treatmentDate,
        diagnosis: recordData['diagnosis'] ?? '',
        veterinarian: recordData['doctorName'] ?? '',
        hospitalName: recordData['hospitalName'] ?? '',
        hospitalAddress: recordData['hospitalAddress'] ?? '',
        examinations: examinations.isEmpty ? null : examinations,
        medications: medications.isEmpty ? null : medications,
        vaccinations: vaccinations.isEmpty ? null : vaccinations,
        memo: recordData['notes'],
        status: recordData['status'] ?? 'UNKNOWN',
        flagCertificated: recordData['flagCertificated'] ?? false,
        pictures: pictures,
        recordKey: recordKey,
        isUpdate: !isOriginal,
        originalRecordKey: isOriginal ? null : originalRecordKey,
      );
    } catch (e) {
      print('Error converting to MedicalRecord: $e');
      return null;
    }
  }
}

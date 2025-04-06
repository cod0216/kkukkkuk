import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_register_provider.dart';
import 'package:kkuk_kkuk/shared/ocr/ocr_service.dart';

class MedicalRecordRegisterController {
  final Ref ref;
  final OcrService _ocrService = OcrService();

  MedicalRecordRegisterController(this.ref);

  Future<Map<String, dynamic>> processImage(File image) async {
    final ocrData = await _ocrService.processImage(image);
    return await ref
        .read(processMedicalRecordImageUseCaseProvider)
        .execute(ocrData);
  }

  Future<void> registerMedicalRecord(
    String petDid,
    Map<String, dynamic> processedData,
  ) async {
    await ref
        .read(medicalRecordRegisterProvider.notifier)
        .registerMedicalRecord(petDid, processedData);
  }
}

final medicalRecordRegisterControllerProvider = Provider((ref) {
  return MedicalRecordRegisterController(ref);
});

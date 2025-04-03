import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/providers/pet/pet_medical_record_register_provider.dart';

class MedicalRecordRegisterController {
  final Ref ref;

  MedicalRecordRegisterController(this.ref);

  Future<void> registerMedicalRecord(String petDid) async {
    await ref
        .read(medicalRecordRegisterProvider.notifier)
        .registerMedicalRecord(petDid);
  }

  bool isLoading() {
    return ref.read(medicalRecordRegisterProvider).isLoading;
  }

  String? getError() {
    return ref.read(medicalRecordRegisterProvider).error;
  }

  String? getTransactionHash() {
    return ref.read(medicalRecordRegisterProvider).transactionHash;
  }
}

final medicalRecordRegisterControllerProvider =
    Provider<MedicalRecordRegisterController>((ref) {
      return MedicalRecordRegisterController(ref);
    });

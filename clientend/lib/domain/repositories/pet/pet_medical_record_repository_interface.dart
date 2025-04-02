import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';

abstract class IPetMedicalRecordRepository {
  Future<List<PetMedicalRecord>> getMedicalRecords(int petId);
  Future<bool> addMedicalRecord(int petId, PetMedicalRecord record);
  Future<List<PetMedicalRecord>> getMedicalRecordsByDateRange(
    int petId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<bool> verifyMedicalRecord(int petId, String recordHash);
  Future<bool> checkAccessPermission(int petId, String userAddress);
  Future<bool> grantAccessPermission(
    int petId,
    String targetAddress,
    DateTime expiryDate,
  );
}

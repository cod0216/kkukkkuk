import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/pet/pet_medical_record_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/add_medical_record_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/check_access_permission_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/get_medical_records_by_date_range_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/get_medical_records_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/grant_access_permission_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/verify_medical_record_usecase.dart';

final getMedicalRecordsUseCaseProvider = Provider<GetMedicalRecordsUseCase>((
  ref,
) {
  final repository = ref.watch(petMedicalRecordRepositoryProvider);
  return GetMedicalRecordsUseCase(repository);
});

final addMedicalRecordUseCaseProvider = Provider<AddMedicalRecordUseCase>((
  ref,
) {
  final repository = ref.watch(petMedicalRecordRepositoryProvider);
  return AddMedicalRecordUseCase(repository);
});

final getMedicalRecordsByDateRangeUseCaseProvider =
    Provider<GetMedicalRecordsByDateRangeUseCase>((ref) {
      final repository = ref.watch(petMedicalRecordRepositoryProvider);
      return GetMedicalRecordsByDateRangeUseCase(repository);
    });

final verifyMedicalRecordUseCaseProvider = Provider<VerifyMedicalRecordUseCase>(
  (ref) {
    final repository = ref.watch(petMedicalRecordRepositoryProvider);
    return VerifyMedicalRecordUseCase(repository);
  },
);

final checkAccessPermissionUseCaseProvider =
    Provider<CheckAccessPermissionUseCase>((ref) {
      final repository = ref.watch(petMedicalRecordRepositoryProvider);
      return CheckAccessPermissionUseCase(repository);
    });

final grantAccessPermissionUseCaseProvider =
    Provider<GrantAccessPermissionUseCase>((ref) {
      final repository = ref.watch(petMedicalRecordRepositoryProvider);
      return GrantAccessPermissionUseCase(repository);
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository.dart';
import 'package:kkuk_kkuk/features/pet/usecase/add_hospital_with_sharing_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/add_medical_record_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_all_attributes_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_medical_record_with_updates_use_case.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_pet_list_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_pet_original_records_use_case.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_species_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/load_medical_records_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/process_medical_record_image_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/register_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/update_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/delete_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_breeds_usecase.dart';

final getPetListUseCaseProvider = Provider<GetPetListUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return GetPetListUseCase(repository);
});

final registerPetUseCaseProvider = Provider<RegisterPetUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return RegisterPetUseCase(repository);
});

final updatePetUseCaseProvider = Provider<UpdatePetUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return UpdatePetUseCase(repository);
});

final deletePetUseCaseProvider = Provider<DeletePetUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return DeletePetUseCase(repository);
});

final getBreedsUseCaseProvider = Provider<GetBreedsUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return GetBreedsUseCase(repository);
});

final getSpeciesUseCaseProvider = Provider<GetSpeciesUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return GetSpeciesUseCase(repository);
});

final getAllAtributesUseCaseProvider = Provider<GetAllAttributesUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return GetAllAttributesUseCase(repository);
});

final grantHospitalAccessUseCaseProvider =
    Provider<AddHospitalWithSharingUseCase>((ref) {
      final repository = ref.watch(petRepositoryProvider);
      return AddHospitalWithSharingUseCase(repository);
    });

final addMedicalRecordUseCaseProvider = Provider<AddMedicalRecordUseCase>((
  ref,
) {
  final repository = ref.watch(petRepositoryProvider);
  return AddMedicalRecordUseCase(repository);
});

final processMedicalRecordImageUseCaseProvider =
    Provider<ProcessMedicalRecordImageUseCase>((ref) {
      final repository = ref.watch(petRepositoryProvider);
      return ProcessMedicalRecordImageUseCase(repository);
    });

final getPetOriginalRecordsUseCaseProvider =
    Provider<GetPetOriginalRecordsUseCase>((ref) {
      final repository = ref.watch(petRepositoryProvider);
      return GetPetOriginalRecordsUseCase(repository);
    });

final getMedicalRecordWithUpdatesUseCaseProvider =
    Provider<GetMedicalRecordWithUpdatesUseCase>((ref) {
      final repository = ref.watch(petRepositoryProvider);
      return GetMedicalRecordWithUpdatesUseCase(repository);
    });

final loadMedicalRecordsUseCaseProvider = Provider<LoadMedicalRecordsUseCase>((
  ref,
) {
  final getPetOriginalRecordsUseCase = ref.watch(
    getPetOriginalRecordsUseCaseProvider,
  );
  final getMedicalRecordWithUpdatesUseCase = ref.watch(
    getMedicalRecordWithUpdatesUseCaseProvider,
  );
  return LoadMedicalRecordsUseCase(
    getPetOriginalRecordsUseCase,
    getMedicalRecordWithUpdatesUseCase,
  );
});

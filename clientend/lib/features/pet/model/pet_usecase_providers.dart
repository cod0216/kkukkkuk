import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository.dart';
import 'package:kkuk_kkuk/features/pet/model/add_hospital_with_sharing_usecase.dart';
import 'package:kkuk_kkuk/features/medical_record/model/add_medical_record_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/get_all_attributes_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/get_pet_list_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/get_species_usecase.dart';
import 'package:kkuk_kkuk/features/medical_record/model/process_medical_record_image_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/register_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/update_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/delete_pet_usecase.dart';
import 'package:kkuk_kkuk/features/pet/model/get_breeds_usecase.dart';

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

final getAllAtributesUseCaseProvider = Provider<GetAllAtributesUseCase>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return GetAllAtributesUseCase(repository);
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/registry_contract_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/add_hospital_with_sharing_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/check_sharing_permission_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_agreement_details_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_hospital_pets_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_medical_records_from_blockchain_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_pet_attributes_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_pet_hospitals_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/remove_hospital_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/revoke_sharing_agreement_usecase.dart';

final getPetAttributesUseCaseProvider = Provider<GetPetAttributesUseCase>((
  ref,
) {
  final repository = ref.watch(registryContractRepositoryProvider);
  return GetPetAttributesUseCase(repository);
});

final addHospitalWithSharingUseCaseProvider =
    Provider<AddHospitalWithSharingUseCase>((ref) {
      final repository = ref.watch(registryContractRepositoryProvider);
      return AddHospitalWithSharingUseCase(repository);
    });

final removeHospitalUseCaseProvider = Provider<RemoveHospitalUseCase>((ref) {
  final repository = ref.watch(registryContractRepositoryProvider);
  return RemoveHospitalUseCase(repository);
});

final revokeSharingAgreementUseCaseProvider =
    Provider<RevokeSharingAgreementUseCase>((ref) {
      final repository = ref.watch(registryContractRepositoryProvider);
      return RevokeSharingAgreementUseCase(repository);
    });

final getAgreementDetailsUseCaseProvider = Provider<GetAgreementDetailsUseCase>(
  (ref) {
    final repository = ref.watch(registryContractRepositoryProvider);
    return GetAgreementDetailsUseCase(repository);
  },
);

final getPetHospitalsUseCaseProvider = Provider<GetPetHospitalsUseCase>((ref) {
  final repository = ref.watch(registryContractRepositoryProvider);
  return GetPetHospitalsUseCase(repository);
});

final getHospitalPetsUseCaseProvider = Provider<GetHospitalPetsUseCase>((ref) {
  final repository = ref.watch(registryContractRepositoryProvider);
  return GetHospitalPetsUseCase(repository);
});

final checkSharingPermissionUseCaseProvider =
    Provider<CheckSharingPermissionUseCase>((ref) {
      final repository = ref.watch(registryContractRepositoryProvider);
      return CheckSharingPermissionUseCase(repository);
    });

// 블록체인에서 진료 기록 조회 유스케이스 Provider
final getMedicalRecordsFromBlockchainUseCaseProvider =
    Provider<GetMedicalRecordsFromBlockchainUseCase>((ref) {
      final repository = ref.watch(registryContractRepositoryProvider);
      return GetMedicalRecordsFromBlockchainUseCase(repository);
    });

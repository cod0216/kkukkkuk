import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/pet_repository.dart';
import 'package:kkuk_kkuk/data/repositories/registry_contract_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/get_pet_list_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/register_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/update_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/delete_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/get_breeds_usecase.dart';

final getPetListUseCaseProvider = Provider<GetPetListUseCase>((ref) {
  final repository = ref.watch(registryContractRepositoryProvider);
  return GetPetListUseCase(repository);
});

final registerPetUseCaseProvider = Provider<RegisterPetUseCase>((ref) {
  final repository = ref.watch(registryContractRepositoryProvider);
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

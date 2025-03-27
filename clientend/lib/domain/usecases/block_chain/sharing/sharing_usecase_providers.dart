import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/sharing_contract_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/accept_sharing_request_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/cancel_sharing_request_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/check_sharing_permission_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/create_sharing_request_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/extend_sharing_period_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/get_pet_sharing_status_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/get_shared_pets_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/get_sharing_requests_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/reject_sharing_request_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/revoke_sharing_access_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/sharing/update_sharing_scope_usecase.dart';

final createSharingRequestUseCaseProvider =
    Provider<CreateSharingRequestUseCase>((ref) {
      final repository = ref.watch(sharingContractRepositoryProvider);
      return CreateSharingRequestUseCase(repository);
    });

final acceptSharingRequestUseCaseProvider =
    Provider<AcceptSharingRequestUseCase>((ref) {
      final repository = ref.watch(sharingContractRepositoryProvider);
      return AcceptSharingRequestUseCase(repository);
    });

final rejectSharingRequestUseCaseProvider =
    Provider<RejectSharingRequestUseCase>((ref) {
      final repository = ref.watch(sharingContractRepositoryProvider);
      return RejectSharingRequestUseCase(repository);
    });

final cancelSharingRequestUseCaseProvider =
    Provider<CancelSharingRequestUseCase>((ref) {
      final repository = ref.watch(sharingContractRepositoryProvider);
      return CancelSharingRequestUseCase(repository);
    });

final revokeSharingAccessUseCaseProvider = Provider<RevokeSharingAccessUseCase>(
  (ref) {
    final repository = ref.watch(sharingContractRepositoryProvider);
    return RevokeSharingAccessUseCase(repository);
  },
);

final getSharingRequestsUseCaseProvider = Provider<GetSharingRequestsUseCase>((
  ref,
) {
  final repository = ref.watch(sharingContractRepositoryProvider);
  return GetSharingRequestsUseCase(repository);
});

final getSharedPetsUseCaseProvider = Provider<GetSharedPetsUseCase>((ref) {
  final repository = ref.watch(sharingContractRepositoryProvider);
  return GetSharedPetsUseCase(repository);
});

final getPetSharingStatusUseCaseProvider = Provider<GetPetSharingStatusUseCase>(
  (ref) {
    final repository = ref.watch(sharingContractRepositoryProvider);
    return GetPetSharingStatusUseCase(repository);
  },
);

final checkSharingPermissionUseCaseProvider =
    Provider<CheckSharingPermissionUseCase>((ref) {
      final repository = ref.watch(sharingContractRepositoryProvider);
      return CheckSharingPermissionUseCase(repository);
    });

final updateSharingScopeUseCaseProvider = Provider<UpdateSharingScopeUseCase>((
  ref,
) {
  final repository = ref.watch(sharingContractRepositoryProvider);
  return UpdateSharingScopeUseCase(repository);
});

final extendSharingPeriodUseCaseProvider = Provider<ExtendSharingPeriodUseCase>(
  (ref) {
    final repository = ref.watch(sharingContractRepositoryProvider);
    return ExtendSharingPeriodUseCase(repository);
  },
);

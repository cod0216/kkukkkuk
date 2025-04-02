import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/blockchain/registry_contract_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_medical_records_from_blockchain_usecase.dart';

// 블록체인에서 진료 기록 조회 유스케이스 Provider
final getMedicalRecordsFromBlockchainUseCaseProvider =
    Provider<GetMedicalRecordsFromBlockchainUseCase>((ref) {
      final repository = ref.watch(registryContractRepositoryProvider);
      return GetMedicalRecordsFromBlockchainUseCase(repository);
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_medical_record.dart';
import 'package:kkuk_kkuk/services/pet_medical_block_chain_service.dart';

class PetMedicalRecordState {
  final List<PetMedicalRecord> records;
  final bool isLoading;
  final String? error;

  PetMedicalRecordState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  PetMedicalRecordState copyWith({
    List<PetMedicalRecord>? records,
    bool? isLoading,
    String? error,
  }) {
    return PetMedicalRecordState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PetMedicalRecordNotifier extends StateNotifier<PetMedicalRecordState> {
  final PetMedicalBlockChainService _service;

  PetMedicalRecordNotifier(this._service) : super(PetMedicalRecordState());

  Future<void> getMedicalRecords(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await _service.getMedicalRecords(petId);
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '진료 기록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  void resetRecords() {
    state = PetMedicalRecordState();
  }
}

final petMedicalRecordProvider =
    StateNotifierProvider<PetMedicalRecordNotifier, PetMedicalRecordState>((
      ref,
    ) {
      final service = ref.watch(petMedicalRecordServiceProvider);
      return PetMedicalRecordNotifier(service);
    });

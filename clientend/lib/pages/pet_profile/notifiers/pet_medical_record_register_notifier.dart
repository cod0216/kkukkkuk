import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/examination.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/features/pet/usecase/add_medical_record_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medication.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/vaccination.dart';

class MedicalRecordRegisterState {
  final bool isLoading;
  final String? error;
  final String? transactionHash;

  const MedicalRecordRegisterState({
    this.isLoading = false,
    this.error,
    this.transactionHash,
  });

  MedicalRecordRegisterState copyWith({
    bool? isLoading,
    String? error,
    String? transactionHash,
  }) {
    return MedicalRecordRegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      transactionHash: transactionHash ?? this.transactionHash,
    );
  }
}

class MedicalRecordRegisterNotifier
    extends StateNotifier<MedicalRecordRegisterState> {
  final AddMedicalRecordUseCase _addMedicalRecordUseCase;

  MedicalRecordRegisterNotifier(this._addMedicalRecordUseCase)
    : super(const MedicalRecordRegisterState());

  Future<void> registerMedicalRecord(
    String petDid,
    Map<String, dynamic> data,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final record = MedicalRecord(
        treatmentDate: DateTime.parse(data['date']),
        diagnosis: data['diagnosis'],
        veterinarian: data['doctorName'],
        hospitalName: data['hospitalName'],
        hospitalAddress: '',
        examinations:
            (data['examinations'] as List)
                .map(
                  (e) => Examination(
                    type: e['type'],
                    key: e['key'],
                    value: e['value'],
                  ),
                )
                .toList(),
        medications:
            (data['medications'] as List)
                .map((e) => Medication(key: e['key'], value: e['value']))
                .toList(),
        vaccinations:
            (data['vaccinations'] as List)
                .map((e) => Vaccination(key: e['key'], value: e['value']))
                .toList(),
        memo: data['notes'],
        status: 'NONE',
        flagCertificated: false,
        pictures: [],
      );

      final txHash = await _addMedicalRecordUseCase.execute(
        petDid: petDid,
        record: record,
      );

      state = state.copyWith(isLoading: false, transactionHash: txHash);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final medicalRecordRegisterProvider = StateNotifierProvider<
  MedicalRecordRegisterNotifier,
  MedicalRecordRegisterState
>((ref) {
  final addMedicalRecordUseCase = ref.watch(addMedicalRecordUseCaseProvider);
  return MedicalRecordRegisterNotifier(addMedicalRecordUseCase);
});

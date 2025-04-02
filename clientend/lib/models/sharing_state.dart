import 'package:kkuk_kkuk/domain/entities/pet/pet.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';

enum SharingStatus {
  initial, // 초기 상태
  processing, // 권한 부여 처리 중
  success, // 권한 부여 성공
  error, // 에러 발생
}

class SharingState {
  final SharingStatus status;
  final Pet? pet;
  final HospitalQRData? hospital;
  final String? transactionHash;
  final String? errorMessage;
  final DateTime? expiryDate;

  const SharingState({
    this.status = SharingStatus.initial,
    this.pet,
    this.hospital,
    this.transactionHash,
    this.errorMessage,
    this.expiryDate,
  });

  SharingState copyWith({
    SharingStatus? status,
    Pet? pet,
    HospitalQRData? hospital,
    String? transactionHash,
    String? errorMessage,
    DateTime? expiryDate,
  }) {
    return SharingState(
      status: status ?? this.status,
      pet: pet ?? this.pet,
      hospital: hospital ?? this.hospital,
      transactionHash: transactionHash ?? this.transactionHash,
      errorMessage: errorMessage ?? this.errorMessage,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  // 초기 상태
  factory SharingState.initial() {
    return const SharingState(status: SharingStatus.initial);
  }

  // 처리 중 상태
  factory SharingState.processing({
    required Pet pet,
    required HospitalQRData hospital,
    DateTime? expiryDate,
  }) {
    return SharingState(
      status: SharingStatus.processing,
      pet: pet,
      hospital: hospital,
      expiryDate: expiryDate,
    );
  }

  // 성공 상태
  factory SharingState.success({
    required Pet pet,
    required HospitalQRData hospital,
    required String transactionHash,
    required DateTime expiryDate,
  }) {
    return SharingState(
      status: SharingStatus.success,
      pet: pet,
      hospital: hospital,
      transactionHash: transactionHash,
      expiryDate: expiryDate,
    );
  }

  // 에러 상태
  factory SharingState.error({
    required String message,
    Pet? pet,
    HospitalQRData? hospital,
  }) {
    return SharingState(
      status: SharingStatus.error,
      pet: pet,
      hospital: hospital,
      errorMessage: message,
    );
  }
}

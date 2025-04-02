class PetMedicalRecord {
  final DateTime treatmentDate; // 진료 일자
  final String recordType; // 기록 유형
  final String? medication; // 약물
  final String? vaccination; // 예방접종 종류
  final String? xRayUrl; // x-ray 이미지 URL
  final String veterinarian; // 주치의
  final String petName; // 이름
  final DateTime? petBirthDate; // 생년월일
  final String petGender; // 성별
  final String guardianName; // 보호자 이름
  final String treatmentDetails; // 진료 내용
  final String? memo; // 메모

  PetMedicalRecord({
    required this.treatmentDate,
    required this.recordType,
    this.medication,
    this.vaccination,
    this.xRayUrl,
    required this.veterinarian,
    required this.petName,
    this.petBirthDate,
    required this.petGender,
    required this.guardianName,
    required this.treatmentDetails,
    this.memo,
  });

  factory PetMedicalRecord.fromJson(Map<String, dynamic> json) {
    return PetMedicalRecord(
      treatmentDate: DateTime.parse(json['진료 일자'] ?? ''),
      recordType: json['기록 유형'] ?? '',
      medication: json['약물'],
      vaccination: json['예방접종 종류'],
      xRayUrl: json['x-ray'],
      veterinarian: json['주치의'] ?? '',
      petName: json['개 이름'] ?? '',
      petBirthDate:
          json['개 생년월일'] != null ? DateTime.parse(json['개 생년월일']) : null,
      petGender: json['개 성별'] ?? '',
      guardianName: json['보호자 이름'] ?? '',
      treatmentDetails: json['진료 내용'] ?? '',
      memo: json['메모'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '진료 일자': treatmentDate.toIso8601String(),
      '기록 유형': recordType,
      '약물': medication,
      '예방접종 종류': vaccination,
      'x-ray': xRayUrl,
      '주치의': veterinarian,
      '개 이름': petName,
      '개 생년월일': petBirthDate?.toIso8601String(),
      '개 성별': petGender,
      '보호자 이름': guardianName,
      '진료 내용': treatmentDetails,
      '메모': memo,
    };
  }

  PetMedicalRecord copyWith({
    DateTime? treatmentDate,
    String? recordType,
    String? medication,
    String? vaccination,
    String? xRayUrl,
    String? veterinarian,
    String? petName,
    DateTime? petBirthDate,
    String? petGender,
    String? guardianName,
    String? treatmentDetails,
    String? memo,
  }) {
    return PetMedicalRecord(
      treatmentDate: treatmentDate ?? this.treatmentDate,
      recordType: recordType ?? this.recordType,
      medication: medication ?? this.medication,
      vaccination: vaccination ?? this.vaccination,
      xRayUrl: xRayUrl ?? this.xRayUrl,
      veterinarian: veterinarian ?? this.veterinarian,
      petName: petName ?? this.petName,
      petBirthDate: petBirthDate ?? this.petBirthDate,
      petGender: petGender ?? this.petGender,
      guardianName: guardianName ?? this.guardianName,
      treatmentDetails: treatmentDetails ?? this.treatmentDetails,
      memo: memo ?? this.memo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetMedicalRecord &&
        other.treatmentDate == treatmentDate &&
        other.recordType == recordType &&
        other.medication == medication &&
        other.vaccination == vaccination &&
        other.xRayUrl == xRayUrl &&
        other.veterinarian == veterinarian &&
        other.petName == petName &&
        other.petBirthDate == petBirthDate &&
        other.petGender == petGender &&
        other.guardianName == guardianName &&
        other.treatmentDetails == treatmentDetails &&
        other.memo == memo;
  }
}

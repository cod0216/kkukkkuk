class PetMedicalRecord {
  final DateTime treatmentDate;
  final String diagnosis;
  final String veterinarian;
  final String hospitalName;
  final String hospitalAddress;
  final List<Examination> examinations;
  final List<Medication> medications;
  final List<Vaccination> vaccinations;
  final String? memo;
  final String status;
  final bool flagCertificated;
  final List<String> pictures;

  PetMedicalRecord({
    required this.treatmentDate,
    required this.diagnosis,
    required this.veterinarian,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.examinations,
    required this.medications,
    required this.vaccinations,
    this.memo,
    required this.status,
    required this.flagCertificated,
    this.pictures = const [],
  });
}

class Examination {
  final String type;
  final String key;
  final String value;

  Examination({required this.type, required this.key, required this.value});
}

class Medication {
  final String key;
  final String value;
  Medication({required this.key, required this.value});
}

class Vaccination {
  final String key;
  final String value;
  Vaccination({required this.key, required this.value});
}

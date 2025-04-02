import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';

class MedicalRecordCard extends StatelessWidget {
  final PetMedicalRecord record;

  const MedicalRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildDiagnosis(),
            if (record.memo != null) ...[
              const SizedBox(height: 12),
              _buildMemo(),
            ],
            if (record.examinations.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildExaminations(),
            ],
            if (record.medications.isNotEmpty ||
                record.vaccinations.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildTreatments(),
            ],
            if (record.pictures.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildPictures(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          '${record.treatmentDate.year}.${record.treatmentDate.month.toString().padLeft(2, '0')}.${record.treatmentDate.day.toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildDiagnosis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          record.diagnosis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          '${record.hospitalName} - ${record.veterinarian}',
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildExaminations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('검사 결과', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ...record.examinations.map(
          (exam) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text('${exam.key}: ${exam.value}'),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (record.medications.isNotEmpty) ...[
          const Text('처방 약물', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...record.medications.map((med) => Text(med)),
          const SizedBox(height: 8),
        ],
        if (record.vaccinations.isNotEmpty) ...[
          const Text('예방 접종', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...record.vaccinations.map((vac) => Text(vac)),
        ],
      ],
    );
  }

  Widget _buildMemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('증상', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(record.memo!, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildPictures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('사진', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: record.pictures.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    record.pictures[index],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

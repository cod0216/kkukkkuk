import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';

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
            _buildTreatmentDetails(),
            const SizedBox(height: 12),
            _buildMedicalInfo(),
            if (record.memo != null) _buildMemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            record.recordType,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        const Spacer(),
        Text(
          '${record.treatmentDate.year}.${record.treatmentDate.month.toString().padLeft(2, '0')}.${record.treatmentDate.day.toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildTreatmentDetails() {
    return Text(
      record.treatmentDetails,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildMedicalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (record.medication != null) _buildInfoItem('약물', record.medication!),
        if (record.vaccination != null)
          _buildInfoItem('예방접종', record.vaccination!),
        _buildInfoItem('주치의', record.veterinarian),
      ],
    );
  }

  Widget _buildMemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text(
          '메모',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(record.memo!, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}

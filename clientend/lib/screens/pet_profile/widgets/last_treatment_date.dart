import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet_medical_record.dart';

/// 최근 진료일 정보를 표시하는 위젯
class LastTreatmentDate extends StatelessWidget {
  final List<PetMedicalRecord> records;

  const LastTreatmentDate({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    // 가장 최근 진료일 찾기
    final latestRecord = records.reduce(
      (a, b) => a.treatmentDate.isAfter(b.treatmentDate) ? a : b,
    );

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '최근 진료일: ${latestRecord.treatmentDate.year}.${latestRecord.treatmentDate.month.toString().padLeft(2, '0')}.${latestRecord.treatmentDate.day.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

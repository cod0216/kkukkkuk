import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/widgets/pet/profile/certification_badge.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;

  const MedicalRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // 다른 카드들과 유사한 스타일 적용 (Container + BoxDecoration)
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 흰색
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.0), // 얇은 테두리
        // boxShadow: [ // 그림자 효과 (선택 사항)
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (날짜 및 인증 배지)
          _buildHeader(context), // context 전달
          const SizedBox(height: 16), // 간격 조정
          // 진단명
          Text(
            record.diagnosis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // 진단명 강조
            ),
          ),
          const SizedBox(height: 6),

          // 병원 및 수의사 정보
          _buildInfoRow(
            context,
            Icons.local_hospital_outlined,
            '${record.hospitalName} / ${record.veterinarian}',
          ), // 아이콘 추가
          const SizedBox(height: 12), // 섹션 간 간격
          // 증상 (메모)
          if (record.memo != null && record.memo!.isNotEmpty) ...[
            _buildSectionTitle(context, '증상 기록'),
            Text(record.memo!, style: TextStyle(color: Colors.grey.shade800)),
            const SizedBox(height: 12),
          ],

          // 검사 결과
          if (record.examinations?.isNotEmpty ?? false) ...[
            _buildSectionTitle(context, '검사 결과'),
            ...record.examinations!.map(
              (exam) => _buildListItem('${exam.key}: ${exam.value}'),
            ),
            const SizedBox(height: 12),
          ],

          // 처방 및 접종
          if (record.medications?.isNotEmpty ??
              false || (record.vaccinations?.isNotEmpty ?? false)) ...[
            _buildSectionTitle(context, '처방 및 접종'),
            if (record.medications?.isNotEmpty ?? false)
              ...record.medications!.map(
                (med) => _buildListItem('${med.key} ${med.value}'),
              ),
            if (record.vaccinations?.isNotEmpty ?? false)
              ...record.vaccinations!.map(
                (vac) => _buildListItem('${vac.key} ${vac.value}'),
              ),
            const SizedBox(height: 12),
          ],

          // 첨부 사진
          if (record.pictures.isNotEmpty) ...[
            _buildSectionTitle(context, '첨부 사진'),
            _buildPictures(),
          ],
        ],
      ),
    );
  }

  // 헤더 위젯 (날짜 포맷 변경 및 스타일 조정)
  Widget _buildHeader(BuildContext context) {
    // 날짜 포맷 변경 (YYYY. MM. DD hh:mm)
    final formattedDate = intl.DateFormat(
      'yyyy. MM. dd HH:mm',
    ).format(record.treatmentDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
      crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
      children: [
        // 날짜 표시
        Text(
          formattedDate,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13), // 스타일 조정
        ),
        // 인증 배지
        CertificationBadge(isCertified: record.flagCertificated),
      ],
    );
  }

  // 정보 행 위젯 (병원/수의사)
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          // 텍스트 길어질 경우 대비
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600, // 약간 굵게
          fontSize: 15,
          color: Theme.of(context).primaryColor.withOpacity(0.9), // 주 색상 활용
        ),
      ),
    );
  }

  // 리스트 아이템 위젯 (검사, 처방 등)
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0, left: 4.0), // 들여쓰기 및 간격
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.grey.shade700)), // 불릿 포인트
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 사진 표시 위젯 (변경 없음)
  Widget _buildPictures() {
    return SizedBox(
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
                // 로딩 및 에러 처리 추가 가능
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                },
                errorBuilder: (context, error, stack) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

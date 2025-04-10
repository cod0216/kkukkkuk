import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard 추가

class HospitalInfoCard extends StatelessWidget {
  const HospitalInfoCard({
    super.key,
    required this.context,
    required this.title,
    required this.content,
  });

  final BuildContext context;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    // 앱의 다른 카드 스타일과 유사하게 변경
    return Container(
      width: double.infinity, // 가로 꽉 채우기
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // 흰색 배경
        borderRadius: BorderRadius.circular(12), // 둥근 모서리
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ), // 얇은 회색 테두리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              // 앱의 섹션 제목 스타일과 유사하게
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            // 내용과 복사 버튼을 가로로 배치
            children: [
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16), // 본문 텍스트 스타일
                ),
              ),
              // DID인 경우 복사 버튼 추가
              if (title == 'DID')
                IconButton(
                  icon: Icon(Icons.copy, size: 18, color: Colors.grey.shade600),
                  tooltip: 'DID 복사',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DID가 클립보드에 복사되었습니다.')),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

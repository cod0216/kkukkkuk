import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/theme/app_text_styles.dart';

class EmptyRecords extends StatelessWidget {
  const EmptyRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '진료 기록이 없습니다',
            style: AppTextStyles.subtitle1.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

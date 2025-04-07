import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/widgets/common/primary_button.dart';

class FindHospitalButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FindHospitalButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PrimaryButton(
        backgroundColor: Colors.orange,
        text: '가까운 병원 찾기',
        onPressed:
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('구현중인 기능입니다.'),
                duration: Duration(seconds: 1),
              ),
            ),
        leadingIcon: const Icon(Icons.qr_code, size: 24),
        isFullWidth: true,
      ),
    );
  }
}

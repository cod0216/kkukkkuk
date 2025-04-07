import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/widgets/common/add_circle_icon.dart';

class AddPetButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? subtitle;

  const AddPetButton({
    super.key,
    this.onTap,
    this.title = '반려동물을\n등록하세요',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            AddPetButtonCircle(
              onTap: onTap ?? () {},
              size: 60,
              iconSize: 30,
              borderWidth: 2.0,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddPetButtonIcon(),
            const SizedBox(height: 24),
            AddPetButtonText(title: title, subtitle: subtitle),
          ],
        ),
      ),
    );
  }
}

class AddPetButtonIcon extends StatelessWidget {
  const AddPetButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: const Icon(Icons.add, size: 30, color: Colors.black),
    );
  }
}

class AddPetButtonText extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AddPetButtonText({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}

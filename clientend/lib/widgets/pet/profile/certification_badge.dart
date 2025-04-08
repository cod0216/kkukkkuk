import 'package:flutter/material.dart';

class CertificationBadge extends StatelessWidget {
  final bool isCertified;

  const CertificationBadge({super.key, required this.isCertified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCertified ? Colors.green.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCertified ? Colors.green.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCertified ? Icons.verified : Icons.pending,
            size: 16,
            color: isCertified ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isCertified ? '인증됨' : '미인증',
            style: TextStyle(
              fontSize: 12,
              color: isCertified ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
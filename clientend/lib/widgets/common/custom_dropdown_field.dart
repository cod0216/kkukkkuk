import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool enabled;
  final bool isRequired;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint),
            items:
                items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: enabled ? onChanged : null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            validator:
                isRequired
                    ? (value) {
                      if (value == null || value.isEmpty) {
                        return '선택해주세요';
                      }
                      return null;
                    }
                    : null,
          ),
        ),
      ],
    );
  }
}

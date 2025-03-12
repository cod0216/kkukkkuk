import 'package:flutter/material.dart';

class PinKeypad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  const PinKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: 12),
          _buildLastRow(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton('취소', onCancelPressed),
        _buildNumberButton('0'),
        _buildActionButton('입력', onDeletePressed),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onNumberPressed(number),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

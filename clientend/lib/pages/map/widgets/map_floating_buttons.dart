import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onCenter;

  const FloatingButtons({
    super.key,
    required this.onRefresh,
    required this.onCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 80,
      child: Column(
        children: [
          _circleIconButton(Icons.refresh_rounded, onRefresh),
          const SizedBox(height: 10),
          _circleIconButton(Icons.location_searching_rounded, onCenter),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

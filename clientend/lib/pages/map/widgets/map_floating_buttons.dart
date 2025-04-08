import 'package:flutter/material.dart';

class FloatingButtons extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final VoidCallback onCenter;

  const FloatingButtons({
    super.key,
    required this.onRefresh,
    required this.onCenter,
  });

  @override
  State<FloatingButtons> createState() => _FloatingButtonsState();
}

class _FloatingButtonsState  extends State<FloatingButtons> {
  @override
  Widget build(BuildContext context) {
    bool isRefreshing = false;

    Future<void> refreshHospitals() async {
      if (isRefreshing) return;
      setState(() {
        isRefreshing = true;
      });
      await widget.onRefresh();
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }

    return Positioned(
      right: 10,
      bottom: 100,
      child: Column(
        children: [
          _circleIconButton(Icons.refresh_rounded, refreshHospitals),
          const SizedBox(height: 10),
          _circleIconButton(Icons.location_searching_rounded, widget.onCenter),
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
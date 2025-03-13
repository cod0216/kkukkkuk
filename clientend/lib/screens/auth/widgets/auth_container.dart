import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const AuthContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Add this wrapper
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min, // Add this
          children: [child],
        ),
      ),
    );
  }
}

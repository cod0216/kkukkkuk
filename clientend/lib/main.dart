import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/theme/app_theme.dart';
import 'package:kkuk_kkuk/routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '꾹꾹',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

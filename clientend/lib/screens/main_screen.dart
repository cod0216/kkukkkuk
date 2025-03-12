import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/widgets/custom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<NavItem>? navItems;

  const MainScreen({super.key, required this.navigationShell, this.navItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomNavigationBar(
        navigationShell: navigationShell,
        items: navItems,
      ),
    );
  }
}
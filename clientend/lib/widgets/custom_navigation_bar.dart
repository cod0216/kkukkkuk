import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String path;

  NavItem({required this.label, required this.icon, required this.path});
}

class CustomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<NavItem>? items;

  const CustomNavigationBar({
    super.key,
    required this.navigationShell,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final defaultItems = [
      NavItem(label: 'Pets', icon: Icons.pets, path: '/pets'),
      NavItem(label: 'MyPage', icon: Icons.person, path: '/mypage'),
    ];

    final navItems = items ?? defaultItems;

    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onTap(context, index),
      items: navItems
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ))
          .toList(),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
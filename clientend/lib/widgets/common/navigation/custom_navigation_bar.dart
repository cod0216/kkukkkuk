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
      NavItem(
        label: 'MyPage',
        icon: Icons.person_outline,
        path: '/mypage',
      ), // MyPage 아이콘 변경
    ];

    final navItems = items ?? defaultItems;

    // 테마에서 primary color 가져오기 (선택된 아이템 색상)
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    // 선택되지 않은 아이템 색상
    const Color unselectedColor = Colors.grey;

    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onTap(context, index),
      items:
          navItems
              .map(
                (item) => BottomNavigationBarItem(
                  // 아이콘 색상은 BottomNavigationBar의 selectedItemColor/unselectedItemColor 속성으로 자동 관리됨
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
      // BottomNavigationBar 스타일링
      type: BottomNavigationBarType.fixed, // 아이템이 많아져도 고정된 스타일 유지
      backgroundColor: Colors.white, // 배경색 흰색으로 설정
      selectedItemColor: selectedColor, // 선택된 아이템 색상 (아이콘 + 라벨)
      unselectedItemColor: unselectedColor, // 선택되지 않은 아이템 색상 (아이콘 + 라벨)
      selectedFontSize: 12.0, // 선택된 라벨 폰트 크기 (이미지와 유사하게 약간 작게)
      unselectedFontSize: 12.0, // 선택되지 않은 라벨 폰트 크기 (이미지와 유사하게 약간 작게)
      elevation: 4.0, // 약간의 그림자 효과 추가 (선택 사항)
      // 아이콘과 라벨 사이 간격 등 미세 조정 필요시 showSelectedLabels, showUnselectedLabels, iconSize 등 활용
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

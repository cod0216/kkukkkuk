import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/screens/splash_screen.dart';
import 'package:kkuk_kkuk/screens/main/main_screen.dart';
import 'package:kkuk_kkuk/screens/main/pets_screen.dart';
import 'package:kkuk_kkuk/screens/main/my_page_screen.dart';
import 'package:kkuk_kkuk/screens/auth/auth_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),

    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              MainScreen(navigationShell: navigationShell),
      branches: [
        // Pets tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pets',
              builder: (context, state) => const PetsScreen(),
            ),
          ],
        ),
        // MyPage tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mypage',
              builder: (context, state) => const MyPageScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(path: '/home', redirect: (context, state) => '/pets'),
  ],
);

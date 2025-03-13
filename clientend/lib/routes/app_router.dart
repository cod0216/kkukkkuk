import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/screens/splash_screen.dart';
import 'package:kkuk_kkuk/screens/main/main_screen.dart';
import 'package:kkuk_kkuk/screens/main/views/pets_view.dart';
import 'package:kkuk_kkuk/screens/main/views/my_page_view.dart';
import 'package:kkuk_kkuk/screens/auth/auth_screen.dart';
import 'package:kkuk_kkuk/screens/pet_profile/pet_profile_screen.dart';
import 'package:kkuk_kkuk/screens/pet_register/pet_register_screen.dart';

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
              builder: (context, state) => const PetsView(),
            ),
          ],
        ),
        // MyPage tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mypage',
              builder: (context, state) => const MyPageView(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(path: '/home', redirect: (context, state) => '/pets'),

    GoRoute(
      path: '/pet-register',
      builder: (context, state) => const PetRegisterScreen(),
    ),

    GoRoute(
      path: '/pet-detail',
      builder: (context, state) => PetProfileScreen(pet: state.extra as Pet),
    ),
  ],
);

import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/viewmodels/auth_view_model.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/screens/splash_screen.dart';
import 'package:kkuk_kkuk/screens/main/main_screen.dart';
import 'package:kkuk_kkuk/screens/main/views/pets_view.dart';
import 'package:kkuk_kkuk/screens/main/views/my_page_view.dart';
import 'package:kkuk_kkuk/screens/auth/auth_screen.dart';
import 'package:kkuk_kkuk/screens/pet_profile/pet_profile_screen.dart';
import 'package:kkuk_kkuk/screens/pet_register/pet_register_screen.dart';
// QR 스캐너 라우트 import 추가
import 'package:kkuk_kkuk/routes/qr_scanner_routes.dart';
import 'package:kkuk_kkuk/screens/wallet/wallet_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),

    // Add wallet creation route
    GoRoute(
      path: '/wallet-creation',
      builder:
          (context, state) =>
              WalletScreen(viewModel: state.extra as AuthViewModel),
    ),

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

    // QR 스캐너 라우트 추가
    ...qrScannerRoutes,
  ],
);

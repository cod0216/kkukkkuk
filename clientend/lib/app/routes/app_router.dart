import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/pet_edit/pet_edit_view.dart';
import 'package:kkuk_kkuk/pages/splash/splash_screen.dart';
import 'package:kkuk_kkuk/pages/main/main_screen.dart';
import 'package:kkuk_kkuk/pages/main/views/pets_view.dart';
import 'package:kkuk_kkuk/pages/main/views/my_page_view.dart';
import 'package:kkuk_kkuk/pages/pet_profile/pet_profile_screen.dart';
import 'package:kkuk_kkuk/pages/pet_register/pet_register_screen.dart';
import 'package:kkuk_kkuk/app/routes/qr_scanner_routes.dart';
import 'package:kkuk_kkuk/pages/wallet/states/wallet_state.dart';
import 'package:kkuk_kkuk/pages/wallet/wallet_screen.dart';
import 'package:kkuk_kkuk/pages/wallet/notifiers/wallet_notifier.dart';
import 'package:kkuk_kkuk/pages/map/map_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    // Add wallet creation route
    GoRoute(
      path: '/wallet-creation',
      builder:
          (context, state) => WalletScreen(
            viewModel:
                state.extra
                    as StateNotifierProvider<WalletNotifier, WalletState>,
          ),
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
    GoRoute(
      path: '/pet/edit',
      builder: (context, state) => PetEditView(pet: state.extra as Pet),
    ),
    // QR 스캐너 라우트 추가
    ...qrScannerRoutes,

    GoRoute(path: '/map',
        builder: (context, state) => MapScreen()
    ),

  ],
);

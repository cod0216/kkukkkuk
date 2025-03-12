import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/screens/splash_screen.dart';
import 'package:kkuk_kkuk/screens/auth/login_screen.dart';
import 'package:kkuk_kkuk/screens/wallet_creation_screen.dart';

// Add other screen imports as needed

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/signin-signup',
      builder: (context, state) => const LoginScreen(), // Changed to LoginScreen
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/wallet-creation',
      builder: (context, state) => const WalletCreationScreen(),
    ),
    // Add other routes as needed
    GoRoute(
      path: '/home',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Home Screen'))),
    ),
  ],
);

import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/sign_in_or_sign_up_screen.dart';
import '../screens/login_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/signin-signup',
      builder: (context, state) => const SignInOrSignUpScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // Add more routes as needed
  ],
);

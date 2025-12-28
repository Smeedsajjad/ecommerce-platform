import 'package:ecommerence/features/auth/screens/login_screen.dart';
import 'package:ecommerence/features/auth/screens/sign_in_screen.dart';
import 'package:ecommerence/features/home/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../storage/secure_storage.dart';

class AppRouter {
  final secureStorage = SecureStorage(const FlutterSecureStorage());

  GoRouter get router => GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isAuthenticated = await secureStorage.hasToken();
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      if (!isAuthenticated && !isLoggingIn && !isSigningUp) {
        return '/login';
      }
      if (isAuthenticated && (isLoggingIn || isSigningUp)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
}

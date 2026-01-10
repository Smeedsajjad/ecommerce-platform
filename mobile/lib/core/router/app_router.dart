import 'package:ecommerence/features/product/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:ecommerence/features/auth/screens/login_screen.dart';
import 'package:ecommerence/features/auth/screens/sign_in_screen.dart';
import 'package:ecommerence/features/home/views/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerence/features/auth/services/auth_service.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to auth state changes and notify the router
    _ref.listen(authServiceProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authServiceProvider);
      final status = authState.status;

      // Determine if the user is currently on an auth-related screen
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      // 1. Loading state:
      // If we are at the app start (initialLocation is /login), stay there.
      // If we are already on login/signup, stay there.
      if (status == AuthStatus.loading) {
        return null;
      }

      // 2. Authenticated:
      // Move to home if currently on auth screens.
      if (status == AuthStatus.authenticated) {
        if (isLoggingIn || isSigningUp) {
          return '/home';
        }
        return null;
      }

      // 3. Unauthenticated / Error:
      // Must be on login or signup screen.
      if (status == AuthStatus.unauthenticated || status == AuthStatus.error) {
        if (!isLoggingIn && !isSigningUp) {
          return '/login';
        }
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product_list',
        name: 'product_list',
        builder: (context, state) => const ProductList(),
      ),
    ],
  );
});

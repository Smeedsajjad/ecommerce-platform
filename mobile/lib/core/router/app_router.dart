import 'package:ecommerence/features/cart/screens/cart_screen.dart';
import 'package:ecommerence/features/product/screens/product_details_screen.dart';
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
    _ref.listen(authServiceProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: ref.watch(routerNotifierProvider),
    initialLocation: '/home',
    redirect: (context, state) {
      final authState = ref.read(authServiceProvider);
      final status = authState.status;

      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      if (status == AuthStatus.loading) {
        return null;
      }

      if (status == AuthStatus.authenticated) {
        if (isLoggingIn || isSigningUp) {
          return '/home';
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
      GoRoute(
        path: '/product_details/:id',
        name: 'product_details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );
});

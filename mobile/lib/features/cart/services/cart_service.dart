import 'package:dio/dio.dart';
import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/features/auth/services/api_service.dart';
import 'package:ecommerence/features/cart/models/cart_model.dart';
import 'package:ecommerence/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  final ApiService _apiService;

  CartService(this._apiService);

  Future<CartModel> getCart() async {
    try {
      final response = await _apiService.getCart();
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CartModel> addToCart(int productId, int quantity) async {
    try {
      final response = await _apiService.addToCart(productId, quantity);
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CartModel> updateCartItem(int itemId, int quantity) async {
    try {
      final response = await _apiService.updateCartItem(itemId, quantity);
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CartModel> deleteCartItem(int itemId) async {
    try {
      final response = await _apiService.deleteCartItem(itemId);
      return CartModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiService.clearCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      final data = e.response!.data as Map;
      if (data.containsKey('message')) {
        return data['message'];
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CartService(apiService);
});

class CartNotifier extends AsyncNotifier<CartModel> {
  @override
  Future<CartModel> build() async {
    final authState = ref.watch(authServiceProvider);
    if (authState.status == AuthStatus.authenticated) {
      return ref.read(cartServiceProvider).getCart();
    }
    // Return empty cart if not authenticated
    return CartModel(id: 0, items: [], total: 0.0);
  }

  Future<void> addItem(int productId, {int quantity = 1}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(cartServiceProvider).addToCart(productId, quantity),
    );
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(cartServiceProvider).updateCartItem(itemId, quantity),
    );
  }

  Future<void> removeItem(int itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(cartServiceProvider).deleteCartItem(itemId),
    );
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(cartServiceProvider).clearCart();
      return ref.read(cartServiceProvider).getCart();
    });
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CartModel>(
  CartNotifier.new,
);

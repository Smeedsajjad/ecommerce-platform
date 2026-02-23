import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/features/auth/services/api_service.dart';
import 'package:ecommerence/features/checkout/models/checkout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// CheckoutService
// ---------------------------------------------------------------------------
class CheckoutService {
  final ApiService _apiService;

  CheckoutService(this._apiService);

  /// Calls GET /checkout/summary — backend validates cart and recalculates
  /// every total. Throws a descriptive string on validation failure.
  Future<CheckoutSummary> getCheckoutSummary() async {
    final response = await _apiService.getCheckoutSummary();
    final data = response.data;
    if (data['success'] == true) {
      return CheckoutSummary.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw data['message'] ?? 'Failed to load checkout summary';
  }

  /// Calls POST /orders — backend validates cart again, creates the order,
  /// creates a Stripe PaymentIntent, and returns client_secret.
  Future<PlaceOrderResult> placeOrder() async {
    final response = await _apiService.placeOrder();
    final data = response.data;
    if (data['success'] == true) {
      return PlaceOrderResult.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw data['message'] ?? 'Failed to place order';
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------
final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CheckoutService(apiService);
});

/// Holds the validated checkout summary fetched from the server.
/// Populated when the user taps "Proceed to Checkout" on the cart screen.
final checkoutSummaryProvider = StateProvider<CheckoutSummary?>((ref) => null);

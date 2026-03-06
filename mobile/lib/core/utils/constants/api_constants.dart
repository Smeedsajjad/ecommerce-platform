import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Added trailing slash to ensure relative paths join correctly in Dio
  static const String baseUrl = 'http://backend2.test/api/';

  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';
  static const String refresh = 'auth/refresh';
  static const String userProfile = 'auth/me';

  static const String products = 'products';
  static const String cart = 'cart';
  static const String checkoutSummary = 'checkout/summary';
  static const String orders = 'orders';

  // Stripe publishable key (safe to expose in the client)
  static final String stripePublishableKey =
      dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
}

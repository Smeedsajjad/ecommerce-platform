import 'package:dio/dio.dart';
import 'package:ecommerence/core/utils/constants/api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post(
      ApiConstants.register,
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response> getMe() async {
    return await _dio.get(ApiConstants.userProfile);
  }

  Future<Response> logout() async {
    return await _dio.post(ApiConstants.logout);
  }

  Future<Response> getCart() async {
    return await _dio.get(ApiConstants.cart);
  }

  Future<Response> addToCart(int productId, int quantity) async {
    return await _dio.post(
      ApiConstants.cart,
      data: {'product_id': productId, 'quantity': quantity},
    );
  }

  Future<Response> updateCartItem(int itemId, int quantity) async {
    return await _dio.put(
      '${ApiConstants.cart}/$itemId',
      data: {'quantity': quantity},
    );
  }

  Future<Response> deleteCartItem(int itemId) async {
    return await _dio.delete('${ApiConstants.cart}/$itemId');
  }

  Future<Response> clearCart() async {
    return await _dio.delete('cart-clear');
  }

  Future<Response> getCheckoutSummary() async {
    return await _dio.get(ApiConstants.checkoutSummary);
  }

  Future<Response> placeOrder() async {
    return await _dio.post(ApiConstants.orders);
  }

  Future<Response> getOrders() async {
    return await _dio.get(ApiConstants.orders);
  }

  Future<Response> getOrder(int orderId) async {
    return await _dio.get('${ApiConstants.orders}/$orderId');
  }
}

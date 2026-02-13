import 'package:dio/dio.dart';
import 'package:ecommerence/core/storage/secure_storage.dart';
import 'package:ecommerence/core/utils/constants/api_constants.dart';

class ApiService {
  final Dio _dio;
  final SecureStorage _storage;

  ApiService(this._dio, this._storage) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.headers["Accept"] = "application/json";

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.deleteTokens();
          }
          return handler.next(error);
        },
      ),
    );
  }

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
    return await _dio.delete('/cart-clear');
  }
}

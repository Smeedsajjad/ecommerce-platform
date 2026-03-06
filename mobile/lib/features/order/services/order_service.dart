import 'package:dio/dio.dart';
import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/core/utils/constants/api_constants.dart';
import 'package:ecommerence/features/order/models/order_model.dart';
import 'package:ecommerence/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderService {
  final Dio _dio;

  OrderService(this._dio);

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.get(ApiConstants.orders);
      return (response.data['data'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
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

final orderProvider = FutureProvider<List<OrderModel>>((ref) async {
  final authState = ref.watch(authServiceProvider);
  if (authState.status != AuthStatus.authenticated) {
    return [];
  }
  final dio = ref.watch(dioProvider);
  return OrderService(dio).getOrders();
});

import 'package:dio/dio.dart';
import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/features/product/models/product_details_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsService {
  final Dio _dio;

  ProductDetailsService(this._dio);

  Future<ProductDetailsModel> getProductDetails(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');
      return ProductDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('Failed to load product details');
    }
  }
}

final productDetailsProvider =
    FutureProvider.family<ProductDetailsModel, String>((ref, productId) async {
      final dio = ref.watch(dioProvider);
      return ProductDetailsService(dio).getProductDetails(productId);
    });

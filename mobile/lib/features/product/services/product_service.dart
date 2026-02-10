import 'package:dio/dio.dart';
import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/core/utils/constants/api_constants.dart';
import 'package:ecommerence/features/product/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiConstants.products);
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

final productProvider = FutureProvider<List<ProductModel>>((ref) async {
  final dio = ref.watch(dioProvider);
  return ProductService(dio).getProducts();
});
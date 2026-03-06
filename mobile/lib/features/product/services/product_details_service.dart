import 'package:dio/dio.dart';
import 'package:ecommerence/core/providers/common_providers.dart';
import 'package:ecommerence/core/utils/constants/api_constants.dart';
import 'package:ecommerence/features/product/models/product_details_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsService {
  final Dio _dio;

  ProductDetailsService(this._dio);

  Future<ProductDetailsModel> getProductDetails(String productId) async {
    try {
      final response = await _dio.get('${ApiConstants.products}/$productId');
      return ProductDetailsModel.fromJson(response.data['data']);
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

final productDetailsProvider =
    FutureProvider.family<ProductDetailsModel, String>((ref, productId) async {
      final dio = ref.watch(dioProvider);
      return ProductDetailsService(dio).getProductDetails(productId);
    });

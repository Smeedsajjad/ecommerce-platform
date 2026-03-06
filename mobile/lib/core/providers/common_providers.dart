import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerence/core/storage/secure_storage.dart';
import 'package:ecommerence/features/auth/services/api_service.dart';

import 'package:ecommerence/core/utils/constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.options.baseUrl = ApiConstants.baseUrl;
  dio.options.headers["Accept"] = "application/json";

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // If we're unauthorized, clear the token locally.
          await storage.deleteTokens();
          // We could also notify an auth state provider here if needed.
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(const FlutterSecureStorage());
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

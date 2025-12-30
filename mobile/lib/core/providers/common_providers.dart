import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerence/core/storage/secure_storage.dart';
import 'package:ecommerence/features/auth/services/api_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(const FlutterSecureStorage());
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiService(dio, storage);
});

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerence/features/auth/models/user.dart';
import 'package:ecommerence/features/auth/models/auth_response.dart';
import 'package:ecommerence/features/auth/services/api_service.dart';
import 'package:ecommerence/core/storage/secure_storage.dart';
import 'package:ecommerence/core/providers/common_providers.dart';

enum AuthStatus { unauthenticated, authenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}

class AuthService extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final SecureStorage _storage;

  AuthService(this._apiService, this._storage) : super(AuthState.loading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await _storage.getAccessToken();
    if (token == null) {
      state = AuthState.unauthenticated();
      return;
    }

    try {
      final response = await _apiService.getMe();
      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final user = User.fromJson(userData);
        state = AuthState.authenticated(user);
      } else {
        await logout();
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        await logout();
      } else {
        state = AuthState.unauthenticated();
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final response = await _apiService.login(email, password);
      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        await _storage.saveTokens(authResponse.accessToken, null);
        state = AuthState.authenticated(authResponse.user);
      } else {
        state = AuthState.error(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      String message = 'An error occurred';
      if (e is DioException) {
        message = e.response?.data['message'] ?? e.message ?? 'Network error';
      }
      state = AuthState.error(message);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = AuthState.loading();
    try {
      final response = await _apiService.register(name, email, password);
      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        await _storage.saveTokens(authResponse.accessToken, null);
        state = AuthState.authenticated(authResponse.user);
      } else {
        state = AuthState.error(response.data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      String message = 'An error occurred';
      if (e is DioException) {
        message = e.response?.data['message'] ?? e.message ?? 'Network error';
      }
      state = AuthState.error(message);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {
      // Ignore logout error
    }
    await _storage.deleteTokens();
    state = AuthState.unauthenticated();
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AuthState.unauthenticated();
    }
  }
}

final authServiceProvider = StateNotifierProvider<AuthService, AuthState>((
  ref,
) {
  final apiService = ref.watch(apiServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthService(apiService, storage);
});

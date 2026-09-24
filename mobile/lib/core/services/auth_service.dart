import 'package:dio/dio.dart';

import '../../models/auth_response.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'token_storage.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final Dio _dio = ApiClient().dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final auth = AuthResponse.fromJson(response.data);

      await _tokenStorage.saveSession(
        token: auth.token,
        refreshToken: auth.refreshToken,
        userId: auth.userId,
      );

      return auth;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw AuthException('Invalid email or password');
      }
      throw AuthException('Something went wrong. Please try again.');
    }
  }

  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'fullName': fullName,
          'password': password,
        },
      );

      final auth = AuthResponse.fromJson(response.data);

      await _tokenStorage.saveSession(
        token: auth.token,
        refreshToken: auth.refreshToken,
        userId: auth.userId,
      );

      return auth;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final serverMsg = e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : null;
        throw AuthException(serverMsg ?? 'Email already used or invalid data');
      }
      throw AuthException('Something went wrong. Please try again.');
    }
  }

  // ✅ دالة Logout (مضافة)
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {
      // حتى لو فشل الطلب، منمسح الجلسة محليًا وننزل المستخدم برا
    } finally {
      await _tokenStorage.clearSession();
    }
  }
}
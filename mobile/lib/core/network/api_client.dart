import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../services/token_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout:
            Duration(seconds: AppConstants.requestTimeoutSeconds),
        receiveTimeout:
            Duration(seconds: AppConstants.requestTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/plain',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Login/Register ما بحتاجوا توكن، الباقي كلهم بحتاجوا
          final needsAuth = !options.path.contains('/Auth/login') &&
              !options.path.contains('/Auth/register');

          if (needsAuth) {
            final token = await _tokenStorage.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (DioException error, handler) {
          // لاحقًا هون منضيف منطق تجديد التوكن (refresh) لو رجع 401
          handler.next(error);
        },
      ),
    );
  }
}
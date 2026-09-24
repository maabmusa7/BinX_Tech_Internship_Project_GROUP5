import 'package:dio/dio.dart';

import '../../models/session_models.dart';
import '../../models/user_me.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class UserService {
  final Dio _dio = ApiClient().dio;

  Future<UserMe> getMe() async {
    final response = await _dio.get(ApiEndpoints.userMe);
    return UserMe.fromJson(response.data);
  }

  Future<void> updateProfile({
    required int userId,
    required String fullName,
  }) async {
    await _dio.patch(
      ApiEndpoints.userById(userId),
      data: {'fullName': fullName},
    );
  }

  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post(
      ApiEndpoints.userChangePassword(userId),
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<List<UserSessionSummary>> getSessions(
    int userId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.userSessions(userId),
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return (response.data['items'] as List)
        .map((s) => UserSessionSummary.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
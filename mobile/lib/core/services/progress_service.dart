import 'package:dio/dio.dart';

import '../../models/user_progress.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProgressService {
  final Dio _dio = ApiClient().dio;

  Future<UserProgress> getProgress(int userId) async {
    final response = await _dio.get(ApiEndpoints.userProgress(userId));
    return UserProgress.fromJson(response.data);
  }
}
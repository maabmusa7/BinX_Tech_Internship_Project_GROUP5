import 'package:dio/dio.dart';

import '../../models/topic.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class TopicsService {
  final Dio _dio = ApiClient().dio;

  Future<List<Topic>> getTopics({String? category, String? search}) async {
    final response = await _dio.get(
      ApiEndpoints.topics,
      queryParameters: {
        if (category != null) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    return (response.data as List)
        .map((t) => Topic.fromJson(t as Map<String, dynamic>))
        .toList();
  }
}
import 'package:dio/dio.dart';

import '../../models/session_models.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class SessionService {
  final Dio _dio = ApiClient().dio;

  Future<SessionStartResult> startSession(int topicId) async {
    final response = await _dio.post(
      ApiEndpoints.sessions,
      data: {'topicId': topicId},
    );
    return SessionStartResult.fromJson(response.data);
  }

  Future<SessionTurnResult> sendTurn({
    required int sessionId,
    String? audioUrl,
    String? textInput,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.sessionTurns(sessionId),
      data: {
        if (audioUrl != null) 'audioUrl': audioUrl,
        if (textInput != null) 'textInput': textInput,
      },
    );
    return SessionTurnResult.fromJson(response.data);
  }

  Future<SessionEndResult> endSession(int sessionId) async {
    final response = await _dio.patch(ApiEndpoints.sessionEnd(sessionId));
    return SessionEndResult.fromJson(response.data);
  }

  Future<ActiveSession?> getActiveSession() async {
    try {
      final response = await _dio.get(ApiEndpoints.sessionsActive);
      if (response.data == null) return null;
      return ActiveSession.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}
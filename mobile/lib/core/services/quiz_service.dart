import 'package:dio/dio.dart';

import '../../models/quiz_question.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class QuizService {
  final Dio _dio = ApiClient().dio;

  Future<List<QuizQuestion>> getQuestions() async {
    final response = await _dio.get(ApiEndpoints.quiz);
    return (response.data as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  Future<QuizResult> submitAnswers({
    required List<Map<String, int>> answers, // [{questionId, selectedOptionId}]
    required int timeTakenSeconds,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.quizSubmit,
      data: {
        'answers': answers,
        'timeTakenSeconds': timeTakenSeconds,
      },
    );
    return QuizResult.fromJson(response.data);
  }
}
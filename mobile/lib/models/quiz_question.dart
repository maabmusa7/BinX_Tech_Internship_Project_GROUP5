class QuizOption {
  final int id;
  final String text;

  QuizOption({required this.id, required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}

class QuizQuestion {
  final int id;
  final String text;
  final String category;
  final String difficulty;
  final List<QuizOption> options;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.difficulty,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      options: (json['options'] as List)
          .map((o) => QuizOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizResult {
  final int totalScore;
  final int correctCount;
  final int totalQuestions;
  final String level;
  final String cefrLevel;
  final int timeTakenSeconds;

  QuizResult({
    required this.totalScore,
    required this.correctCount,
    required this.totalQuestions,
    required this.level,
    required this.cefrLevel,
    required this.timeTakenSeconds,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      totalScore: json['totalScore'] as int,
      correctCount: json['correctCount'] as int,
      totalQuestions: json['totalQuestions'] as int,
      level: json['level'] as String,
      cefrLevel: json['cefrLevel'] as String,
      timeTakenSeconds: json['timeTakenSeconds'] as int,
    );
  }
}
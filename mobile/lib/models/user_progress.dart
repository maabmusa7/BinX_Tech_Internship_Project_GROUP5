class TopicProgress {
  final String topicName;
  final int sessionsCount;
  final double averageScore;
  final String status;

  TopicProgress({
    required this.topicName,
    required this.sessionsCount,
    required this.averageScore,
    required this.status,
  });

  factory TopicProgress.fromJson(Map<String, dynamic> json) {
    return TopicProgress(
      topicName: json['topicName'] as String,
      sessionsCount: json['sessionsCount'] as int,
      averageScore: (json['averageScore'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}

class SessionScorePoint {
  final DateTime date;
  final double score;

  SessionScorePoint({required this.date, required this.score});

  factory SessionScorePoint.fromJson(Map<String, dynamic> json) {
    return SessionScorePoint(
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toDouble(),
    );
  }
}

class UserProgress {
  final int currentStreak;
  final int totalCompletedSessions;
  final double overallAverageScore;
  final int totalXp;
  final int totalMinutesSpoken;
  final String cefrLevel;
  final List<TopicProgress> topicsPracticed;
  final List<SessionScorePoint> recentSessionScores;

  UserProgress({
    required this.currentStreak,
    required this.totalCompletedSessions,
    required this.overallAverageScore,
    required this.totalXp,
    required this.totalMinutesSpoken,
    required this.cefrLevel,
    required this.topicsPracticed,
    required this.recentSessionScores,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      currentStreak: json['currentStreak'] as int,
      totalCompletedSessions: json['totalCompletedSessions'] as int,
      overallAverageScore: (json['overallAverageScore'] as num).toDouble(),
      totalXp: json['totalXp'] as int,
      totalMinutesSpoken: json['totalMinutesSpoken'] as int,
      cefrLevel: json['cefrLevel'] as String,
      topicsPracticed: (json['topicsPracticed'] as List)
          .map((t) => TopicProgress.fromJson(t as Map<String, dynamic>))
          .toList(),
      recentSessionScores: (json['recentSessionScores'] as List)
          .map((s) => SessionScorePoint.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
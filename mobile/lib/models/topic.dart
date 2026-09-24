class Topic {
  final int id;
  final String name;
  final String description;
  final String difficulty;
  final String category;
  final int estimatedMinutes;
  final String sessionMission;
  final int maxTurns;
  final int completedSessionsCount;
  final double masteryPercent;
  final String progressStatus;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.estimatedMinutes,
    required this.sessionMission,
    required this.maxTurns,
    required this.completedSessionsCount,
    required this.masteryPercent,
    required this.progressStatus,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      sessionMission: json['sessionMission'] as String,
      maxTurns: json['maxTurns'] as int,
      completedSessionsCount: json['completedSessionsCount'] as int,
      masteryPercent: (json['masteryPercent'] as num).toDouble(),
      progressStatus: json['progressStatus'] as String,
    );
  }
}
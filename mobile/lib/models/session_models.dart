class SessionStartResult {
  final int id;
  final String topicName;
  final String topicCategory;
  final String sessionMission;
  final String status;
  final DateTime startedAt;
  final String openingLine;
  final int maxTurns;

  SessionStartResult({
    required this.id,
    required this.topicName,
    required this.topicCategory,
    required this.sessionMission,
    required this.status,
    required this.startedAt,
    required this.openingLine,
    required this.maxTurns,
  });

  factory SessionStartResult.fromJson(Map<String, dynamic> json) {
    return SessionStartResult(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      topicCategory: json['topicCategory'] as String,
      sessionMission: json['sessionMission'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      openingLine: json['openingLine'] as String,
      maxTurns: json['maxTurns'] as int,
    );
  }
}

class SessionTurnResult {
  final int turnNumber;
  final String transcribedText;
  final String aiReplyText;
  final double pronunciationScore;
  final double fluencyScore;
  final String feedbackText;
  final String? phonemeFocusSound;
  final String? phonemeTip;
  final String? nativeAudioUrl;

  SessionTurnResult({
    required this.turnNumber,
    required this.transcribedText,
    required this.aiReplyText,
    required this.pronunciationScore,
    required this.fluencyScore,
    required this.feedbackText,
    this.phonemeFocusSound,
    this.phonemeTip,
    this.nativeAudioUrl,
  });

  factory SessionTurnResult.fromJson(Map<String, dynamic> json) {
    return SessionTurnResult(
      turnNumber: json['turnNumber'] as int,
      transcribedText: json['transcribedText'] as String? ?? '',
      aiReplyText: json['aiReplyText'] as String? ?? '',
      pronunciationScore:
          (json['pronunciationScore'] as num?)?.toDouble() ?? 0,
      fluencyScore: (json['fluencyScore'] as num?)?.toDouble() ?? 0,
      feedbackText: json['feedbackText'] as String? ?? '',
      phonemeFocusSound: json['phonemeFocusSound'] as String?,
      phonemeTip: json['phonemeTip'] as String?,
      nativeAudioUrl: json['nativeAudioUrl'] as String?,
    );
  }
}

class SessionEndResult {
  final int sessionId;
  final double summaryScore;
  final double avgPronunciation;
  final double avgFluency;
  final double avgVocabulary;
  final int xpEarned;
  final int totalXp;
  final int currentStreak;
  final String cefrLevel;

  SessionEndResult({
    required this.sessionId,
    required this.summaryScore,
    required this.avgPronunciation,
    required this.avgFluency,
    required this.avgVocabulary,
    required this.xpEarned,
    required this.totalXp,
    required this.currentStreak,
    required this.cefrLevel,
  });

  factory SessionEndResult.fromJson(Map<String, dynamic> json) {
    return SessionEndResult(
      sessionId: json['sessionId'] as int,
      summaryScore: (json['summaryScore'] as num).toDouble(),
      avgPronunciation: (json['avgPronunciation'] as num).toDouble(),
      avgFluency: (json['avgFluency'] as num).toDouble(),
      avgVocabulary: (json['avgVocabulary'] as num).toDouble(),
      xpEarned: json['xpEarned'] as int,
      totalXp: json['totalXp'] as int,
      currentStreak: json['currentStreak'] as int,
      cefrLevel: json['cefrLevel'] as String,
    );
  }
}

class ActiveSession {
  final int id;
  final String topicName;
  final String status;
  final DateTime startedAt;
  final double summaryScore;
  final int maxTurns;
  final List<SessionTurnResult> turns;

  ActiveSession({
    required this.id,
    required this.topicName,
    required this.status,
    required this.startedAt,
    required this.summaryScore,
    required this.maxTurns,
    required this.turns,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      summaryScore: (json['summaryScore'] as num).toDouble(),
      maxTurns: json['maxTurns'] as int,
      turns: (json['turns'] as List)
          .map((t) => SessionTurnResult.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UserSessionSummary {
  final int id;
  final String topicName;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double summaryScore;

  UserSessionSummary({
    required this.id,
    required this.topicName,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.summaryScore,
  });

  factory UserSessionSummary.fromJson(Map<String, dynamic> json) {
    return UserSessionSummary(
      id: json['id'] as int,
      topicName: json['topicName'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      summaryScore: (json['summaryScore'] as num).toDouble(),
    );
  }
}
class AuthResponse {
  final int userId;
  final String token;
  final DateTime expiresAt;
  final String refreshToken;
  final String email;
  final String fullName;
  final String role;
  final String level;
  final String cefrLevel;
  final int currentStreak;
  final int cosmicXp;

  AuthResponse({
    required this.userId,
    required this.token,
    required this.expiresAt,
    required this.refreshToken,
    required this.email,
    required this.fullName,
    required this.role,
    required this.level,
    required this.cefrLevel,
    required this.currentStreak,
    required this.cosmicXp,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as int,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      refreshToken: json['refreshToken'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      level: json['level'] as String,
      cefrLevel: json['cefrLevel'] as String,
      currentStreak: json['currentStreak'] as int,
      cosmicXp: json['cosmicXp'] as int,
    );
  }
}
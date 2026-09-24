class UserMe {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final bool isActive;
  final String level;
  final String cefrLevel;
  final int cosmicXp;
  final int currentStreak;

  UserMe({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.level,
    required this.cefrLevel,
    required this.cosmicXp,
    required this.currentStreak,
  });

  factory UserMe.fromJson(Map<String, dynamic> json) {
    return UserMe(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      level: json['level'] as String,
      cefrLevel: json['cefrLevel'] as String,
      cosmicXp: json['cosmicXp'] as int,
      currentStreak: json['currentStreak'] as int,
    );
  }
}
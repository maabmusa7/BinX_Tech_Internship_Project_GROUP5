class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/api/Auth/login';
  static const String register = '/api/Auth/register';
  static const String refresh = '/api/Auth/refresh';
  static const String logout = '/api/Auth/logout';
  static const String forgotPassword = '/api/Auth/forgot-password';
  static const String resetPassword = '/api/Auth/reset-password';

  // Quiz
  static const String quiz = '/api/Quiz';
  static const String quizSubmit = '/api/Quiz/submit';

  // Topics
  static const String topics = '/api/Topics';

  // Sessions
  static const String sessions = '/api/Sessions';
  static const String sessionsActive = '/api/Sessions/active';
  static String sessionById(int id) => '/api/Sessions/$id';
  static String sessionTurns(int id) => '/api/Sessions/$id/turns';
  static String sessionEnd(int id) => '/api/Sessions/$id/end';

  // Users
  static const String userMe = '/api/users/me';
  static String userSessions(int id) => '/api/users/$id/sessions';
  static String userProgress(int id) => '/api/users/$id/progress';
  static String userChangePassword(int id) =>
      '/api/users/$id/change-password';
  static String userById(int id) => '/api/users/$id';
}
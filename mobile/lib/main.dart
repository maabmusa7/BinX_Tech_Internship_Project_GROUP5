import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/quiz/placement_quiz_screen.dart';
import 'features/quiz/quiz_intro_screen.dart';
import 'features/quiz/quiz_result_screen.dart';
import 'features/session/conversation_screen.dart';
import 'features/session/session_complete_screen.dart';
import 'features/session/session_intro_screen.dart';
import 'features/shell/main_shell.dart';
import 'features/splash/splash_screen.dart';
import 'models/quiz_question.dart';
import 'models/session_models.dart';
import 'models/topic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ElioApp());
}

class ElioApp extends StatelessWidget {
  const ElioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ELIO',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.quizIntro: (context) => const QuizIntroScreen(),
        AppRoutes.placementQuiz: (context) => const PlacementQuizScreen(),

        AppRoutes.quizResult: (context) {
          final result =
              ModalRoute.of(context)!.settings.arguments as QuizResult;
          return QuizResultScreen(
            result: result,
            onStartPracticing: () => Navigator.pushReplacementNamed(
                context, AppRoutes.mainShell),
            onReviewAnswers: () {},
          );
        },

        AppRoutes.mainShell: (context) => const MainShell(),

        AppRoutes.session: (context) {
          final topic = ModalRoute.of(context)!.settings.arguments as Topic;
          return SessionIntroScreen(topic: topic);
        },

        AppRoutes.sessionPractice: (context) {
          final session = ModalRoute.of(context)!.settings.arguments
              as SessionStartResult;
          return ConversationScreen(session: session);
        },

        AppRoutes.sessionComplete: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return SessionCompleteScreen(
            result: args['result'] as SessionEndResult,
            topicName: args['topicName'] as String,
            onViewProgress: () => Navigator.pushReplacementNamed(
                context, AppRoutes.mainShell),
            onPracticeAgain: () => Navigator.pushReplacementNamed(
                context, AppRoutes.mainShell),
          );
        },
      },
    );
  }
}
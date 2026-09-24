import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/quiz_question.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;
  final VoidCallback onStartPracticing;
  final VoidCallback onReviewAnswers;

  const QuizResultScreen({
    super.key,
    required this.result,
    required this.onStartPracticing,
    required this.onReviewAnswers,
  });

  int get _scorePercent =>
      ((result.correctCount / result.totalQuestions) * 100).round();

  String get _timeTakenLabel {
    final m = result.timeTakenSeconds ~/ 60;
    final s = result.timeTakenSeconds % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.loginBackground, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _TopBar(onBack: () => Navigator.maybePop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        const _MascotBadge(),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Your English Level',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.auto_awesome,
                                color: AppColors.accent, size: 18),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Great diagnostic run! Your speech roadmap has '
                          'been tailored to your current voice profile.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _LevelCard(
                          levelLabel: result.level.toUpperCase(),
                          levelRange: 'B1 - B2',
                          cefrTier: 'CEFR TIER: ${result.level.toUpperCase()}',
                          scorePercent: _scorePercent,
                          correctCount: result.correctCount,
                          totalQuestions: result.totalQuestions,
                          timeTaken: _timeTakenLabel,
                        ),
                        const SizedBox(height: 16),
                        const _SummaryText(),
                        const SizedBox(height: 16),
                        const _CalibrationNote(),
                        const SizedBox(height: 20),
                        const _RecommendedTopicsHeader(),
                        const SizedBox(height: 12),
                        const _RecommendedTopicTile(
                          icon: Icons.coffee_outlined,
                          title: 'Ordering at a Café & Restaurant',
                          duration: '6 min spoken session',
                        ),
                        const SizedBox(height: 10),
                        const _RecommendedTopicTile(
                          icon: Icons.work_outline,
                          title: 'Casual Work Introductions',
                          duration: '8 min spoken session',
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: onStartPracticing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: AppColors.buttonShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Start Practicing',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onReviewAnswers,
                  child: const Text(
                    'Review Quiz Answers',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.pill,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back,
                size: 18, color: AppColors.textDark),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.pill,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 13, color: AppColors.primary),
              SizedBox(width: 5),
              Text('ASSESSMENT COMPLETE',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: 0.3,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: Image.asset(
              'assets/images/mascot_happy.png',
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sentiment_satisfied_alt_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 40,
            child: Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String levelLabel;
  final String levelRange;
  final String cefrTier;
  final int scorePercent;
  final int correctCount;
  final int totalQuestions;
  final String timeTaken;

  const _LevelCard({
    required this.levelLabel,
    required this.levelRange,
    required this.cefrTier,
    required this.scorePercent,
    required this.correctCount,
    required this.totalQuestions,
    required this.timeTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_outlined,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(levelLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(levelRange,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(cefrTier,
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 0.3,
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('$scorePercent%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$correctCount of $totalQuestions Correct',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    const Text('Diagnostic Score',
                        style: TextStyle(
                            fontSize: 10.5, color: Colors.white70)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 13, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(timeTaken,
                      style: const TextStyle(
                          fontSize: 11.5, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'You have a solid foundation in core grammar, vocabulary, and '
      'everyday sentence structures. Your main opportunity is building '
      'spoken fluency, spontaneous response speed, and natural phoneme '
      'pronunciation.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.textMuted),
    );
  }
}

class _CalibrationNote extends StatelessWidget {
  const _CalibrationNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Level Calibration',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 3),
                Text(
                  'This starting level is based on your written quiz. It '
                  'will automatically calibrate and adjust after your '
                  'first live spoken conversation with ELIO.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTopicsHeader extends StatelessWidget {
  const _RecommendedTopicsHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recommended Starting Topics',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            )),
        Text('LEVEL B1',
            style: TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
      ],
    );
  }
}

class _RecommendedTopicTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;

  const _RecommendedTopicTile({
    required this.icon,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.iconCircle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 11, color: AppColors.textGrey),
                    const SizedBox(width: 3),
                    Text(duration,
                        style: const TextStyle(
                            fontSize: 10.5, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/session_models.dart';

class SessionCompleteScreen extends StatelessWidget {
  final SessionEndResult result;
  final String topicName;
  final VoidCallback onViewProgress;
  final VoidCallback onPracticeAgain;

  const SessionCompleteScreen({
    super.key,
    required this.result,
    required this.topicName,
    required this.onViewProgress,
    required this.onPracticeAgain,
  });

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
                        const SizedBox(height: 8),
                        const _MascotHappy(),
                        const SizedBox(height: 14),
                        const Text('Great Conversation!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            )),
                        const SizedBox(height: 4),
                        Text(
                          '$topicName completed',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12.5, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 18),
                        _ResonanceCard(
                          percent: result.summaryScore.clamp(0, 100).round(),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.record_voice_over_outlined,
                                title: 'Pronunciation',
                                subtitle: 'Clear & Natural\narticulations',
                                percent: result.avgPronunciation
                                    .clamp(0, 100)
                                    .round(),
                                trendUp: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.graphic_eq_rounded,
                                title: 'Fluency',
                                subtitle: 'Good Rhythm,\nMinor Pauses',
                                percent:
                                    result.avgFluency.clamp(0, 100).round(),
                                trendUp: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.menu_book_outlined,
                                title: 'Vocabulary\nVariety',
                                subtitle: 'Great Word\nChoices & Idioms',
                                percent: result.avgVocabulary
                                    .clamp(0, 100)
                                    .round(),
                                trendUp: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _StreakBanner(
                          streakDays: result.currentStreak,
                          xp: result.xpEarned,
                        ),
                        const SizedBox(height: 14),
                        const _PolishNextCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: onViewProgress,
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
                        Text('View Full Progress',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onPracticeAgain,
                    icon: const Icon(Icons.refresh_rounded,
                        size: 17, color: AppColors.primary),
                    label: const Text('Practice Again',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        )),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
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
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.pill,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back,
                size: 17, color: AppColors.textDark),
          ),
        ),
        const Text('ELIO',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            )),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.iconCircle,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 16),
        ),
      ],
    );
  }
}

class _MascotHappy extends StatelessWidget {
  const _MascotHappy();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
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
          size: 36,
        ),
      ),
    );
  }
}

class _ResonanceCard extends StatelessWidget {
  final int percent;
  const _ResonanceCard({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SPEECH RESONANCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.3,
                    )),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$percent%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(left: 6, bottom: 5),
                      child: Text('• Good',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Smooth conversation cadence with clear '
                    'phoneme delivery.',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 5,
                    backgroundColor: AppColors.background,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
                const Icon(Icons.mic_none_rounded,
                    color: AppColors.primary, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int percent;
  final bool trendUp;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                height: 1.2,
              )),
          const SizedBox(height: 3),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8.5,
                color: AppColors.textGrey,
                height: 1.25,
              )),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$percent%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
              const SizedBox(width: 3),
              Icon(
                trendUp ? Icons.trending_up_rounded : Icons.auto_awesome,
                size: 12,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  final int streakDays;
  final int xp;

  const _StreakBanner({required this.streakDays, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$streakDays Day Streak Unlocked',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
                const Text('Consistent speech habits forge mastery',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('+$xp Cosmic XP',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}

class _PolishNextCard extends StatelessWidget {
  const _PolishNextCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_outline,
                  size: 15, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('What to Polish Next',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          const _PolishItem(
            title: 'Sound Focus',
            description: 'Practice soft "th" in "with" & "three".',
            icon: Icons.volume_up_outlined,
          ),
          const SizedBox(height: 10),
          const _PolishItem(
            title: 'Pacing',
            description: 'Great speech tempo (118 words/min).',
            icon: Icons.timer_outlined,
          ),
        ],
      ),
    );
  }
}

class _PolishItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _PolishItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
              const SizedBox(height: 2),
              Text(description,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.iconCircle,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: AppColors.primary),
        ),
      ],
    );
  }
}
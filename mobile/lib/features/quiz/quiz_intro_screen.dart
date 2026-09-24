import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

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
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const _MascotHeader(),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Let's find your level",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right,
                                color: AppColors.accent, size: 22),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '10 quick questions, about 2 minutes. '
                          "We'll calibrate your starting topics and speech "
                          'tempo to match your natural flow.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _FeatureRow(
                          icon: Icons.grid_view_rounded,
                          title: '10 Quick Questions',
                          description:
                              'Bite-sized multiple choice, zero stress, '
                              'completed under 2 minutes.',
                        ),
                        const SizedBox(height: 14),
                        const _FeatureRow(
                          icon: Icons.mic_off_outlined,
                          title: 'Text-Only Assessment',
                          description:
                              'No voice or speaking required here. '
                              'Take it quietly anywhere.',
                        ),
                        const SizedBox(height: 14),
                        const _FeatureRow(
                          icon: Icons.autorenew_rounded,
                          title: 'Dynamically Calibrated',
                          description:
                              'ELIO seamlessly re-tunes after your first '
                              'conversational voice practice.',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock_outline_rounded,
                                size: 14, color: AppColors.textGrey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Establishes your baseline and syncs with "
                                "ELIO's AI engine",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ],
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
                    onPressed: () {
                      // TODO: Navigator.pushNamed(context, AppRoutes.quizQuestions);
                    },
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
                        Text('Start Quiz',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // TODO: تخطي الكويز -> اعتباره Beginner افتراضيًا
                    // Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  child: const Text(
                    'Skip for now (Start at Beginner)',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const _BottomStatsRow(),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar: back button + "LEVEL ASSESSMENT" pill + streak/star icon
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CircleIconButton(icon: Icons.arrow_back, onTap: onBack),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.pill,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 13, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'LEVEL ASSESSMENT',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const _CircleIconButton(icon: Icons.star_rounded, iconColor: AppColors.accent),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.pill,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor ?? AppColors.textDark),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mascot with floating badges ("A1-C2" / "Fast & Gentle")
// ---------------------------------------------------------------------------

class _MascotHeader extends StatelessWidget {
  const _MascotHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: Image.asset(
              'assets/images/mascot_reading.png',
              errorBuilder: (_, __, ___) => const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 12,
            child: _FloatingBadge(
              icon: Icons.auto_awesome,
              label: 'A1 - C2',
            ),
          ),
          Positioned(
            bottom: 10,
            right: 4,
            child: _FloatingBadge(
              icon: Icons.bolt_rounded,
              label: 'Fast & Gentle',
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FloatingBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feature row (icon circle + title + description)
// ---------------------------------------------------------------------------

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.iconCircle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 3),
                Text(description,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: AppColors.textGrey,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom stats row: Adaptive AI / CEFR Aligned / ~120 Sec
// ---------------------------------------------------------------------------

class _BottomStatsRow extends StatelessWidget {
  const _BottomStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatChip(icon: Icons.shield_outlined, label: 'Adaptive AI'),
        const SizedBox(width: 18),
        _StatChip(icon: Icons.star_outline_rounded, label: 'CEFR Aligned'),
        const SizedBox(width: 18),
        _StatChip(icon: Icons.access_time, label: '~120 Sec'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
      ],
    );
  }
}
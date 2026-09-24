import 'package:flutter/material.dart';

import '../../core/services/progress_service.dart';
import '../../core/services/token_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_progress.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _progressService = ProgressService();
  final _tokenStorage = TokenStorage();

  UserProgress? _progress;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final userId = await _tokenStorage.getUserId();
      if (userId == null) throw Exception('No user session');
      final progress = await _progressService.getProgress(userId);
      setState(() => _progress = progress);
    } catch (e) {
      setState(() => _errorMessage = 'Could not load progress.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ELIO',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    )),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.iconCircle,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_errorMessage!,
                                style: const TextStyle(
                                    color: AppColors.textGrey)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: _load,
                                child: const Text('Retry')),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding:
                              const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FluencyChartCard(progress: _progress!),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                      child: _MiniStat(
                                          icon:
                                              Icons.local_fire_department,
                                          value:
                                              '${_progress!.currentStreak} Days',
                                          label: 'ACTIVE',
                                          iconColor: AppColors.accent)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _MiniStat(
                                          icon: Icons.mic_none_rounded,
                                          value:
                                              '${_progress!.totalMinutesSpoken} Mins',
                                          label: 'SPOKEN')),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _MiniStat(
                                          icon: Icons.graphic_eq_rounded,
                                          value:
                                              '${_progress!.overallAverageScore.round()}%',
                                          label: 'PRON. AVG')),
                                ],
                              ),
                              const SizedBox(height: 22),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Topic Mastery',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (_progress!.topicsPracticed.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                      'No topics practiced yet — start a session!',
                                      style: TextStyle(
                                          color: AppColors.textGrey)),
                                )
                              else
                                ..._progress!.topicsPracticed.map((t) =>
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: _MasteryTile(item: t),
                                    )),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _FluencyChartCard extends StatelessWidget {
  final UserProgress progress;
  const _FluencyChartCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final scores = progress.recentSessionScores;
    final maxScore = scores.isEmpty
        ? 1.0
        : scores.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    final normalized = scores
        .map((s) => maxScore == 0 ? 0.0 : s.score / maxScore)
        .toList();
    final labels = scores
        .map((s) => '${s.date.day}/${s.date.month}')
        .toList();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('Speaking Fluency',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      )),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${progress.currentStreak} Day Streak',
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB4790B),
                    )),
              ),
            ],
          ),
          Text('Last ${scores.length} sessions',
              style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
          const SizedBox(height: 14),
          if (normalized.isEmpty)
            const SizedBox(
              height: 90,
              child: Center(
                child: Text('No session data yet',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ),
            )
          else ...[
            SizedBox(
              height: 90,
              child: CustomPaint(
                size: const Size(double.infinity, 90),
                painter: _LineChartPainter(scores: normalized),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels
                  .map((d) => Text(d,
                      style: const TextStyle(
                          fontSize: 9.5, color: AppColors.textGrey)))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.tune_rounded,
                  size: 12, color: AppColors.textGrey),
              const SizedBox(width: 5),
              const Text('CEFR Level',
                  style: TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(progress.cefrLevel,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> scores;
  _LineChartPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.length < 2) return;

    final points = <Offset>[];
    final stepX = size.width / (scores.length - 1);
    for (int i = 0; i < scores.length; i++) {
      final x = stepX * i;
      final y = size.height * (1 - scores[i]);
      points.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.accent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      path.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.primary;
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawCircle(points[i], 3, dotPaint);
    }
    canvas.drawCircle(points.last, 4.5, Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.scores != scores;
}

// ---------------------------------------------------------------------------

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
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
          Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                fontSize: 8.5,
                color: AppColors.textGrey,
                letterSpacing: 0.3,
              )),
        ],
      ),
    );
  }
}

class _MasteryTile extends StatelessWidget {
  final TopicProgress item;
  const _MasteryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMastered = item.status.toLowerCase() == 'mastered';

    return Container(
      padding: const EdgeInsets.all(12),
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
            child: const Icon(Icons.forum_outlined,
                color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(item.topicName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          )),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isMastered
                            ? Colors.green.withValues(alpha: 0.15)
                            : AppColors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item.status,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: isMastered
                                ? Colors.green.shade700
                                : const Color(0xFF1E5FA8),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                    '${item.sessionsCount} sessions • Avg ${item.averageScore.round()}%',
                    style: const TextStyle(
                        fontSize: 10.5, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
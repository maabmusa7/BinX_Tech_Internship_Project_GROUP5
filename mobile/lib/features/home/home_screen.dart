import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/session_service.dart';
import '../../core/services/topics_service.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/session_models.dart';
import '../../models/topic.dart';
import '../../models/user_me.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userService = UserService();
  final _topicsService = TopicsService();
  final _sessionService = SessionService();

  UserMe? _me;
  List<Topic> _topics = [];
  ActiveSession? _activeSession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait<Object?>([
        _userService.getMe(),
        _topicsService.getTopics(),
        _sessionService.getActiveSession(),
      ]);
      setState(() {
        _me = results[0] as UserMe?;
        _topics = (results[1] as List?)?.cast<Topic>() ?? [];
        _activeSession = results[2] as ActiveSession?;
      });
    } catch (_) {
      // نسيبها فاضية، الواجهة بتتعامل مع null
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final suggested = _topics.isNotEmpty ? _topics.first : null;
    final exploreList = _topics.length > 1 ? _topics.sublist(1) : <Topic>[];

    return RefreshIndicator(
      onRefresh: _load,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 20),
              Text(
                'HELLO 👋 ${(_me?.fullName ?? '').split(' ').first.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              _buildBadges(),
              const SizedBox(height: 20),
              if (suggested != null) _buildReadyCard(context, suggested),
              if (_activeSession != null) ...[
                const SizedBox(height: 24),
                _buildSectionHeader(
                  title: 'Continue Practicing',
                  trailing:
                      'Turn ${_activeSession!.turns.length} of ${_activeSession!.maxTurns}',
                ),
                const SizedBox(height: 12),
                _buildContinueCard(_activeSession!),
              ],
              const SizedBox(height: 24),
              _buildSectionHeader(
                title: 'Explore Topics',
                trailing: 'View All >',
                isLink: true,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.topics);
                },
              ),
              const SizedBox(height: 12),
              _buildExploreTopics(context, exploreList),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('ELIO',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1,
            )),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.iconPurpleBg,
            border: Border.all(color: AppColors.cardBorder, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 22),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Row(
      children: [
        _buildBadge(Icons.school_outlined,
            '${_me?.level ?? '-'} • ${_me?.cefrLevel ?? '-'}'),
        const SizedBox(width: 8),
        _buildBadge(Icons.local_fire_department,
            '${_me?.currentStreak ?? 0} Day Streak'),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              )),
        ],
      ),
    );
  }

  Widget _buildReadyCard(BuildContext context, Topic topic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F3AAF), Color(0xFF6D4CAC)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ready to speak?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    )),
                const SizedBox(height: 8),
                Text(topic.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                      height: 1.4,
                    )),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.session,
                        arguments: topic);
                  },
                  icon: const Icon(Icons.mic, size: 16),
                  label: const Text('Start Practice',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.headset_mic,
                size: 40, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String trailing,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            )),
        GestureDetector(
          onTap: onTap,
          child: Text(trailing,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isLink ? AppColors.primary : AppColors.textMuted,
              )),
        ),
      ],
    );
  }

  Widget _buildContinueCard(ActiveSession session) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.iconPurpleBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work_outline,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.topicName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )),
                const SizedBox(height: 4),
                Text('${session.turns.length}/${session.maxTurns} turns',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreTopics(BuildContext context, List<Topic> topics) {
    if (topics.isEmpty) {
      return const Text('No more topics right now.',
          style: TextStyle(color: AppColors.textGrey));
    }
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final t = topics[i];
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.session, arguments: t),
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.iconPurpleBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.chat_bubble_outline,
                          color: AppColors.primary, size: 24),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(t.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    children: [
                      Text(t.difficulty,
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textMuted)),
                      const Spacer(),
                      const Icon(Icons.access_time,
                          size: 9, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      Text('${t.estimatedMinutes} min',
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
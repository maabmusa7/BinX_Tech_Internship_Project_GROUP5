import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/topics_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/topic.dart';
import '../../models/topic_category.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final _topicsService = TopicsService();
  final _searchController = TextEditingController();

  TopicCategory _selectedCategory = TopicCategory.all;
  List<Topic> _topics = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final topics = await _topicsService.getTopics(
        category: _selectedCategory.apiValue,
        search: _searchController.text.trim(),
      );
      setState(() => _topics = topics);
    } catch (e) {
      setState(() => _errorMessage = 'Could not load topics. Pull to retry.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
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
              child: RefreshIndicator(
                onRefresh: _loadTopics,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Choose Your Topic',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          )),
                      const SizedBox(height: 6),
                      const Text(
                        'Practice real conversations tailored to your goals.',
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 18),
                      _SearchBar(
                        controller: _searchController,
                        onSubmitted: (_) => _loadTopics(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: TopicCategory.values.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final cat = TopicCategory.values[i];
                            return _FilterChip(
                              label: cat.label,
                              selected: cat == _selectedCategory,
                              onTap: () {
                                setState(() => _selectedCategory = cat);
                                _loadTopics();
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child:
                              Center(child: CircularProgressIndicator()),
                        )
                      else if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(_errorMessage!,
                                style: const TextStyle(
                                    color: AppColors.textGrey)),
                          ),
                        )
                      else if (_topics.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text('No topics found.',
                                style:
                                    TextStyle(color: AppColors.textGrey)),
                          ),
                        )
                      else
                        ..._topics.map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _TopicCard(
                                topic: t,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.session,
                                    arguments: t,
                                  );
                                },
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _SearchBar({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                hintText: 'Search topics, idioms, or scenarios...',
                hintStyle:
                    TextStyle(fontSize: 12.5, color: AppColors.hintText),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback onTap;

  const _TopicCard({required this.topic, required this.onTap});

  IconData get _icon {
    switch (topic.category) {
      case 'Travel':
        return Icons.flight_outlined;
      case 'Career':
        return Icons.work_outline;
      case 'Social':
        return Icons.forum_outlined;
      case 'DailyLife':
        return Icons.local_cafe_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasProgress = topic.completedSessionsCount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.iconCircle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (topic.progressStatus.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(topic.progressStatus,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB4790B),
                              )),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text('${topic.difficulty} · ${topic.category}',
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(topic.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(height: 6),
                  Text(topic.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textMuted,
                      )),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (hasProgress) ...[
                        Text('${topic.masteryPercent.clamp(0, 100).round()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            )),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                              '${topic.completedSessionsCount} sessions completed',
                              style: const TextStyle(
                                  fontSize: 10.5, color: AppColors.textGrey)),
                        ),
                      ] else
                        const Expanded(child: SizedBox()),
                      const Icon(Icons.access_time,
                          size: 11, color: AppColors.textGrey),
                      const SizedBox(width: 3),
                      Text('${topic.estimatedMinutes} mins',
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
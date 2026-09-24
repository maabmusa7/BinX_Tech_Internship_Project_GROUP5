import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/quiz_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/quiz_question.dart';

class PlacementQuizScreen extends StatefulWidget {
  const PlacementQuizScreen({super.key});

  @override
  State<PlacementQuizScreen> createState() => _PlacementQuizScreenState();
}

class _PlacementQuizScreenState extends State<PlacementQuizScreen> {
  final _quizService = QuizService();

  List<QuizQuestion> _questions = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  int _currentIndex = 0;
  int? _selectedOptionId;
  final Map<int, int> _answers = {}; // questionId -> selectedOptionId

  final DateTime _startedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final questions = await _quizService.getQuestions();
      setState(() => _questions = questions);
    } catch (e) {
      setState(() => _errorMessage = 'Could not load the quiz. Please retry.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectOption(int optionId) =>
      setState(() => _selectedOptionId = optionId);

  Future<void> _next() async {
    if (_selectedOptionId == null) return;
    final question = _questions[_currentIndex];
    _answers[question.id] = _selectedOptionId!;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionId = _answers[_questions[_currentIndex].id];
      });
    } else {
      await _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    final timeTaken = DateTime.now().difference(_startedAt).inSeconds;

    try {
      final result = await _quizService.submitAnswers(
        answers: _answers.entries
            .map((e) => {'questionId': e.key, 'selectedOptionId': e.value})
            .toList(),
        timeTakenSeconds: timeTaken,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.quizResult,
        arguments: result,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not submit the quiz. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage ?? 'No questions available.',
                  style: const TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadQuestions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final isLast = _currentIndex == _questions.length - 1;

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
                const _TopBar(),
                const SizedBox(height: 18),
                _ProgressHeader(
                  questionNumber: _currentIndex + 1,
                  totalQuestions: _questions.length,
                  progress: progress,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _QuestionCard(question: question),
                        const SizedBox(height: 16),
                        ...List.generate(question.options.length, (i) {
                          final letter = String.fromCharCode(65 + i);
                          final option = question.options[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OptionTile(
                              letter: letter,
                              text: option.text,
                              selected: _selectedOptionId == option.id,
                              onTap: () => _selectOption(option.id),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: (_selectedOptionId == null || _isSubmitting)
                        ? null
                        : _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      disabledBackgroundColor:
                          AppColors.button.withValues(alpha: 0.4),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: AppColors.buttonShadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isLast ? 'Finish Quiz' : 'Next Question',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  size: 18),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
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
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.quiz_outlined, color: AppColors.primary, size: 20),
        Icon(Icons.auto_awesome, color: AppColors.accent, size: 18),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final double progress;

  const _ProgressHeader({
    required this.questionNumber,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Question $questionNumber of $totalQuestions',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                )),
            Text('${(progress * 100).round()}% Complete',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.cardWhite,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  const _QuestionCard({required this.question});

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
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${question.category} • ${question.difficulty}'.toUpperCase(),
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.3,
              )),
          const SizedBox(height: 14),
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.letter,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: selected
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.iconCircle,
              child: Text(letter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : AppColors.primary,
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textDark,
                  )),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? Colors.white : AppColors.hintText,
            ),
          ],
        ),
      ),
    );
  }
}
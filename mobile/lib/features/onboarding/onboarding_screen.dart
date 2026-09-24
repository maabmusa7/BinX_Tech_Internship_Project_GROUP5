import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import 'controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // البيانات مباشرة هنا (بدون Model)
  static const List<Map<String, String>> pages = [
    {
      'badge': 'START NEW',
      'title': 'Explore',
      'description': 'Pick a real-life situation to practice.',
    },
    {
      'badge': 'ELIO SPEAKING',
      'title': 'Learn',
      'description': 'Speak naturally — ELIO is listening.',
    },
    {
      'badge': 'ELIO THINKING',
      'title': 'Interact',
      'description': 'Get instant feedback, then keep the conversation going.',
    },
    {
      'badge': 'NEW STREAK',
      'title': 'Open',
      'description': 'Watch your world grow, one language at a time.',
    },
  ];

  Future<void> onFinish(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      builder: (context, child) {
        final controller = context.read<OnboardingController>();
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.splashTop, AppColors.splashBottom],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // الشخصية + الشارة
                  Consumer<OnboardingController>(
                    builder: (context, value, child) {
                      final badge = pages[value.currentIndex]['badge']!;
                      return Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.emoji_emotions,
                              size: 50,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.accent, width: 1.5),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // الـ PageView
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(pages[index]);
                      },
                    ),
                  ),

                  // مؤشر الصفحات
                  Consumer<OnboardingController>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) {
                            final isActive = value.currentIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.accent
                                    : AppColors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // زر NEXT / GET STARTED
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Consumer<OnboardingController>(
                      builder: (context, value, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!value.isLastPage) {
                                controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                onFinish(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              value.isLastPage
                                  ? 'GET STARTED →'
                                  : 'NEXT →',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              page['title']!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              page['description']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.splashTextLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
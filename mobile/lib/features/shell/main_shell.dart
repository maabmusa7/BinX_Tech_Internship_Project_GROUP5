import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../progress/progress_screen.dart';
import '../settings/settings_screen.dart';
import '../topics/topics_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex = widget.initialIndex;

  // كل شاشة تتبنى مرة واحدة بس وتضل بالذاكرة (IndexedStack بيحافظ على الـ state)
  final List<Widget> _screens = const [
    HomeScreen(),
    TopicsScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: AppColors.cardWhite,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Setting'),
        ],
      ),
    );
  }
}
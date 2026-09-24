import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentIndex = 0;
  bool isLastPage = false;

  void onPageChanged(int index) {
    currentIndex = index;
    isLastPage = index == 3; // 4 صفحات (0,1,2,3)
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
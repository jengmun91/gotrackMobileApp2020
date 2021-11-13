import 'package:flutter/material.dart';

class MainBottomNavBarProvider with ChangeNotifier {
  int currentIndex = 0;

  void setCurrentIndex(int value) {
    currentIndex = value;
    notifyListeners();
  }
}

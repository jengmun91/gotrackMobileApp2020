import 'package:flutter/material.dart';

class TrackingNumberInputProvider with ChangeNotifier {
  String text = '';

  void setText(String value) {
    text = value.toUpperCase();
    notifyListeners();
  }

  void clear() {
    text = '';
    notifyListeners();
  }
}

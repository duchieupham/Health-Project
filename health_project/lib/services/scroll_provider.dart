import 'package:flutter/material.dart';

class ScrollProvider with ChangeNotifier {
  // double _scrollPosition = 0;
  bool _isToolHidden = false;
  bool _backToTop = false;

  //get scrollPosition => _scrollPosition;
  get isToolHidden => _isToolHidden;
  get backToTop => _backToTop;

  // void updateScrollPosition(double index) {
  //   _scrollPosition = index;
  //   notifyListeners();
  // }

  void updateBackToTop(bool check) {
    _backToTop = check;
    notifyListeners();
  }

  void updateToolHidden(bool check) {
    _isToolHidden = check;
    notifyListeners();
  }
}

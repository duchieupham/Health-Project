import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _tabIndex = 0;

  get tabIndex => _tabIndex;

  void updateTabIndex(int index) async {
    _tabIndex = index;
    notifyListeners();
  }
}

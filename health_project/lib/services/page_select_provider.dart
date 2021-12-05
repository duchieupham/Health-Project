import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';

class PageSelectProvider with ChangeNotifier {
  int _indexSelected = DefaultNumeral.INITIAL_PAGE;
  int _notificationCount = 0;

  get indexSelected => _indexSelected;
  get notificationCount => _notificationCount;

  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void updateNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }
}

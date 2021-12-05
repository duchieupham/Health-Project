import 'package:flutter/material.dart';

class NotificationCountProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void updateNotificationCount(int count) {
    _count = count;
    notifyListeners();
  }
}

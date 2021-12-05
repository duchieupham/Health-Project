import 'package:flutter/material.dart';

class PhoneConfirmProvider with ChangeNotifier {
  bool _isConfirmedBoxShow = false;
  bool _checkMatchWithOldPhone = false;

  get confirmedBoxShow => _isConfirmedBoxShow;
  get checkMatchWithOldPhone => _checkMatchWithOldPhone;

  void updateMatchWithOldPhone(bool check) {
    _checkMatchWithOldPhone = check;
    notifyListeners();
  }

  void updateConfirmedBox(bool check) {
    _isConfirmedBoxShow = check;
    notifyListeners();
  }
}

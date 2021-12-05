import 'package:flutter/material.dart';

class GenderSelectProvider with ChangeNotifier {
  //Man: true, Women: false
  bool _manCheck = false;
  bool _womenCheck = false;

  get manCheck => _manCheck;
  get womenCheck => _womenCheck;

  void initialGender(String gender) {
    if (gender == 'man') {
      _manCheck = true;
      _womenCheck = false;
    } else {
      _manCheck = false;
      _womenCheck = true;
    }
  }

  void updateGender(String gender) {
    if (gender == 'man') {
      _manCheck = true;
      _womenCheck = false;
    } else {
      _manCheck = false;
      _womenCheck = true;
    }
    notifyListeners();
  }

  String getGender() {
    String gender = '';
    if (_manCheck == true && _womenCheck == false) {
      gender = 'man';
    } else {
      gender = 'woman';
    }
    return gender;
  }
}

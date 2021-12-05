import 'package:flutter/material.dart';
import 'package:health_project/services/peripheral_helper.dart';

class PeripheralConnectingProvider with ChangeNotifier {
  bool _isPeripheralConnected = PeripheralHelper.instance.isPeripheralConnect();

  get isPeripheralConnected => _isPeripheralConnected;

  void updatePeripheralConnect(bool check) {
    _isPeripheralConnected = check;
    notifyListeners();
  }
}

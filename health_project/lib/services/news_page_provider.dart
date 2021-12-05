import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';

//this provider is using for pagging
class NewsPageProvider with ChangeNotifier {
  int _currentPage = 0;
  int _currentHomePage = 0;
  bool _hasListEnd = false;
  bool _hasHomePageEnd = false;

  get currentPage => _currentPage;
  get hasListEnd => _hasListEnd;
  get currentHomePage => _currentHomePage;
  get hasHomePageEnd => _hasHomePageEnd;

  void turnNextPage() {
    _currentPage += DefaultNumeral.ROW_LOADING;
    notifyListeners();
  }

  void turnNextHomePage() {
    _currentHomePage += DefaultNumeral.ROW_LOADING;
    notifyListeners();
  }

  void prevToFirstPage() {
    _currentPage = 0;
    notifyListeners();
  }

  void prevToFirstHomePage() {
    _currentHomePage = 0;
    notifyListeners();
  }

  void updateListEnd(bool value) {
    _hasListEnd = value;
    notifyListeners();
  }

  void updateHomePageEnd(bool value) {
    _hasHomePageEnd = value;
    notifyListeners();
  }
}

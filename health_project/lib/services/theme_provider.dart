import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/services/theme_helper.dart';

class ThemeProvider with ChangeNotifier {
  String _themeSystem = ThemeHelper.instance.getTheme();

  get themeSystem => _themeSystem;

  void updateTheme(String mode) async {
    ThemeHelper.instance.updateTheme(mode);
    _themeSystem = ThemeHelper.instance.getTheme();
    notifyListeners();
  }

  int getThemeIndex() {
    int index = 0;
    if (ThemeHelper.instance.getTheme() == DefaultTheme.THEME_LIGHT) {
      index = 0;
    } else if (ThemeHelper.instance.getTheme() == DefaultTheme.THEME_DARK) {
      index = 1;
    } else if (ThemeHelper.instance.getTheme() == DefaultTheme.THEME_SYSTEM) {
      index = 2;
    }
    return index;
  }

  //update theme by index
  void updateThemeByIndex(int index) {
    String mode = '';
    if (index == 0) {
      mode = DefaultTheme.THEME_LIGHT;
    } else if (index == 1) {
      mode = DefaultTheme.THEME_DARK;
    } else {
      mode = DefaultTheme.THEME_SYSTEM;
    }
    ThemeHelper.instance.updateTheme(mode);
    _themeSystem = ThemeHelper.instance.getTheme();
    notifyListeners();
  }
}

import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConsrtructor();

  static final ThemeHelper _instance = ThemeHelper._privateConsrtructor();
  static ThemeHelper get instance => _instance;
  //
  void initialTheme() {
    sharedPrefs.setString('THEME_SYSTEM', DefaultTheme.THEME_SYSTEM);
  }

  void updateTheme(String theme) {
    if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
        sharedPrefs.getString('THEME_SYSTEM') == null) {
      initialTheme();
    }
    sharedPrefs.setString('THEME_SYSTEM', theme);
  }

  String getTheme() {
    if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
        sharedPrefs.getString('THEME_SYSTEM') == null) {
      initialTheme();
    }
    return sharedPrefs.getString('THEME_SYSTEM')!;
  }
}

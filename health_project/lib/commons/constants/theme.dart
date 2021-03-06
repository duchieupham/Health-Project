import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTheme {
  //COLOR
  static const Color BLACK = Color(0xFF000000);
  static const Color BLACK_DARK = Color(0xFF1B1C1E);
  static const Color BLACK_BUTTON = Color(0xFF303030);
  static const Color BLACK_LIGHT = Color(0xFF464646);
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color GREY_BUTTON = Color(0xFFEEEFF3);
  static const Color GREY_VIEW = Color(0xFFEEEFF3);
  static const Color GREY_TEXT = Color(0xFF666A72);
  static const Color GREY_LIGHT = Color(0xFF9BA5B9);
  static const Color RED_TEXT = Color(0xFFFF0A0A);
  static const Color BLUE_TEXT = Color(0xFF0A7AFF);
  static const Color RED_CALENDAR = Color(0xFFF5233C);
  static const Color TRANSPARENT = Color(0x00000000);
  static const Color GREY_TOP_TAB_BAR = Color(0xFFBEC1C9);
  static const Color SUCCESS_STATUS = Color(0xFF06B271);
  static const Color GREEN = Color(0xFF00CA28);
  static const Color DARK_GREEN = Color(0xFF0D5F34);
  static const Color BLUE_LIGHT = Color(0xFF96D8FF);
  static const Color DARK_PURPLE = Color(0xFF7951F8);
  static const Color VERY_PERI = Color(0xFF6868AC);
  static const Color LIGHT_PURPLE = Color(0xFFAF93FF);
  static const Color LIGHT_PINK = Color(0xFFFF8AB0);
  static const Color DARK_PINK = Color(0xFFFD246B);
  static const Color NEON = Color(0xFF4DFF34);
  static const Color BLUE_WEATHER = Color(0xFF4BAEB2);
  static const Color RED_NEON = Color(0xFFFF5377);
  static const Color PURPLE_NEON = Color(0xFF605DFF);
  static const Color ORANGE = Color(0xFFFF9C1B);
  //WEATHER POINT COLOR
  static const Color SUNNY_COLOR = Color(0xFFF23535);
  static const Color HOT_COLOR = Color(0xFFE4BE4A);
  static const Color WARM_COLOR = Color(0xFF75F181);
  static const Color COOL_COLOR = Color(0xFF7EE4A7);
  static const Color COLD_COLOR = Color(0xFF52B5D3);
  static const Color WINTER_COLOR = Color(0xFF338AED);
  //NOTI COLOR
  static const Color RED_NOTI_1 = Color(0xFFFAC4DF);
  static const Color RED_NOTI = Color(0xFFF291BB);
  static const Color GREEN_NOTI_1 = Color(0xFFC4FAEE);
  static const Color GREEN_NOTI = Color(0xFF91F2D9);

  //
  //BANNER WEATHER COLOR
  static const Color BANNER_DAY1 = Color(0xFF26B0FD);
  static const Color BANNER_DAY2 = Color(0xFF014C8B);
  static const Color BANNER_NIGHT1 = Color(0xFF3D2BFF);
  static const Color BANNER_NIGHT2 = Color(0xFF0D0132);
  //COLOR WEATHER BG
  static const Color DARK_NIGHT = Color(0xFF6361C5);
  static const Color LIGHT_DAY = Color(0xFF42D8F2);
  //THEME NAME
  static const String THEME_LIGHT = 'LIGHT';
  static const String THEME_DARK = 'DARK';
  static const String THEME_SYSTEM = 'SYSTEM';

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor);
  }

  static BoxDecoration cardDecorationWithOpacity(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor.withOpacity(0.9),
    );
  }

  static Widget buildButtonBox({
    required VoidCallback onTap,
    required double borderRadius,
    required Widget child,
  }) {
    return InkWell(
      hoverColor: DefaultTheme.LIGHT_PURPLE.withOpacity(0.5),
      focusColor: DefaultTheme.LIGHT_PURPLE.withOpacity(0.5),
      splashColor: DefaultTheme.LIGHT_PURPLE.withOpacity(0.5),
      highlightColor: DefaultTheme.LIGHT_PURPLE.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      onTap: onTap,
      child: child,
    );
  }
}

//theme data
class DefaultThemeData {
  final BuildContext context;

  const DefaultThemeData({required this.context});

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DefaultTheme.BLACK,
      buttonColor: DefaultTheme.BLACK_BUTTON,
      primaryColor: DefaultTheme.BLACK,
      accentColor: DefaultTheme.GREY_LIGHT,
      hoverColor: DefaultTheme.BLACK_LIGHT,
      cursorColor: DefaultTheme.WHITE,
      cardColor: DefaultTheme.BLACK_BUTTON,
      shadowColor: DefaultTheme.WHITE,
      hintColor: DefaultTheme.WHITE,
      indicatorColor: DefaultTheme.LIGHT_PINK,
      splashColor: DefaultTheme.TRANSPARENT,
      highlightColor: DefaultTheme.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: DefaultTheme.WHITE,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: DefaultTheme.TRANSPARENT,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
      ),
    );
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: DefaultTheme.WHITE,
      buttonColor: DefaultTheme.WHITE,
      primaryColor: DefaultTheme.WHITE,
      hoverColor: DefaultTheme.WHITE,
      cursorColor: DefaultTheme.GREY_TEXT,
      accentColor: DefaultTheme.GREY_TEXT,
      cardColor: DefaultTheme.GREY_VIEW,
      shadowColor: DefaultTheme.GREY_LIGHT,
      indicatorColor: DefaultTheme.DARK_PINK,
      hintColor: DefaultTheme.BLACK,
      splashColor: DefaultTheme.TRANSPARENT,
      highlightColor: DefaultTheme.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: DefaultTheme.BLACK,
          ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: DefaultTheme.TRANSPARENT,
      ),
    );
  }
}

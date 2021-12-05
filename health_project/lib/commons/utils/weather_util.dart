import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/time_util.dart';

class WeatherUtil {
  const WeatherUtil._privateConsrtructor();

  static final WeatherUtil _instance = WeatherUtil._privateConsrtructor();
  static WeatherUtil get instance => _instance;

  String getUrlIconByWeatherState(String weatherStateAbbr) {
    const String prefix = 'assets/images/';
    String asset = '';
    if (weatherStateAbbr == 'sn') {
      asset = prefix + 'ic-snow.png';
    } else if (weatherStateAbbr == 'sl') {
      asset = prefix + 'ic-sleet.png';
    } else if (weatherStateAbbr == 'h') {
      asset = prefix + 'ic-sleet.png';
    } else if (weatherStateAbbr == 't') {
      asset = prefix + 'ic-thunderstorm.png';
    } else if (weatherStateAbbr == 'hr') {
      asset = prefix + 'ic-heavy-rain.png';
    } else if (weatherStateAbbr == 'lr') {
      asset = prefix + 'ic-light-rain.png';
    } else if (weatherStateAbbr == 's') {
      asset = prefix + 'ic-showers.png';
    } else if (weatherStateAbbr == 'hc') {
      asset = prefix + 'ic-heavy-cloud.png';
    } else if (weatherStateAbbr == 'lc' &&
        !TimeUtil.instance.changeWeatherWidgetByTime()) {
      asset = prefix + 'ic-light-cloud.png';
    } else if (weatherStateAbbr == 'lc' &&
        TimeUtil.instance.changeWeatherWidgetByTime()) {
      asset = prefix + 'ic-night.png';
    } else if (weatherStateAbbr == 'c' &&
        !TimeUtil.instance.changeWeatherWidgetByTime()) {
      asset = prefix + 'ic-clear.png';
    } else if (weatherStateAbbr == 'c' &&
        TimeUtil.instance.changeWeatherWidgetByTime()) {
      asset = prefix + 'ic-night.png';
    }
    return asset;
  }

  String getWeatherDescription(String weatherStateAbbr) {
    String description = '';
    if (weatherStateAbbr == 'sn') {
      description = 'Trời có tuyết';
    } else if (weatherStateAbbr == 'sl') {
      description = 'Trời có mưa đá một vài nơi';
    } else if (weatherStateAbbr == 'h') {
      description = 'Trời có mưa đá';
    } else if (weatherStateAbbr == 't') {
      description = 'Trời có giông vài nơi';
    } else if (weatherStateAbbr == 'hr') {
      description = 'Trời mưa nặng hạt';
    } else if (weatherStateAbbr == 'lr') {
      description = 'Trời mưa';
    } else if (weatherStateAbbr == 's') {
      description = 'Trời có mưa vài nơi';
    } else if (weatherStateAbbr == 'hc') {
      description = 'Trời nhiều mây';
    } else if (weatherStateAbbr == 'lc') {
      description = 'Mây rải rác';
    } else if (weatherStateAbbr == 'c') {
      description = 'Trời quang';
    }
    return description;
  }

  AssetImage getBackgroundWidget() {
    //changeWeatherWidgetByTime return true when night
    return AssetImage(
      (TimeUtil.instance.changeWeatherWidgetByTime())
          ? 'assets/images/bg-wnight.png'
          : 'assets/images/bg-wday.png',
    );
  }

  Widget getBackgroundWeatherImage(BuildContext context) {
    //changeWeatherWidgetByTime return true when night
    return Image.asset(
      (TimeUtil.instance.changeWeatherWidgetByTime())
          ? 'assets/images/bg-wnight.png'
          : 'assets/images/bg-wday.png',
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fitWidth,
    );
  }

  Color getWeatherBackgroundColor() {
    return (TimeUtil.instance.changeWeatherWidgetByTime())
        ? DefaultTheme.DARK_NIGHT
        : DefaultTheme.LIGHT_DAY;
  }

  Color getTimeSunColor() {
    return (TimeUtil.instance.changeWeatherWidgetByTime())
        ? DefaultTheme.DARK_PURPLE.withOpacity(0.9)
        : DefaultTheme.BLUE_WEATHER.withOpacity(0.9);
  }

  LinearGradient getGradientWeather(double maxTemp, double minTemp) {
    final double sunnyPoint = 35;
    final double hotPoint = 30;
    final double warmPoint = 25;
    final double coolPoint = 20;
    final double coldPoint = 15;
    final double winterPoint = 10;
    List<Color> colors = [];
    List<double> points = [
      sunnyPoint,
      hotPoint,
      warmPoint,
      coolPoint,
      coldPoint,
      winterPoint,
    ];

    List<double> selectedPoints = [];

    selectedPoints
        .addAll(points.where((element) => element < maxTemp + 5).toList());
    selectedPoints.removeWhere((element) => element <= minTemp - 5);

    if (selectedPoints.contains(sunnyPoint)) {
      colors.add(DefaultTheme.SUNNY_COLOR.withOpacity(0.8));
    }
    if (selectedPoints.contains(hotPoint)) {
      colors.add(DefaultTheme.HOT_COLOR.withOpacity(0.8));
    }
    if (selectedPoints.contains(warmPoint)) {
      colors.add(DefaultTheme.WARM_COLOR.withOpacity(0.8));
    }
    if (selectedPoints.contains(coolPoint)) {
      colors.add(DefaultTheme.COOL_COLOR.withOpacity(0.8));
    }
    if (selectedPoints.contains(coldPoint)) {
      colors.add(DefaultTheme.COLD_COLOR.withOpacity(0.8));
    }
    if (selectedPoints.contains(winterPoint)) {
      colors.add(DefaultTheme.WINTER_COLOR.withOpacity(0.8));
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    );
  }

  Color getTempuratureColor(double currentTemp) {
    return (currentTemp >= 35)
        ? DefaultTheme.SUNNY_COLOR
        : (currentTemp < 35 && currentTemp >= 30)
            ? DefaultTheme.HOT_COLOR
            : (currentTemp < 30 && currentTemp >= 25)
                ? DefaultTheme.WARM_COLOR
                : (currentTemp < 25 && currentTemp >= 20)
                    ? DefaultTheme.COOL_COLOR
                    : (currentTemp < 20 && currentTemp >= 15)
                        ? DefaultTheme.COLD_COLOR
                        : DefaultTheme.WINTER_COLOR;
  }

  Color getVisibilityColor(double visibility) {
    return (visibility < 10)
        ? DefaultTheme.RED_NEON
        : (visibility >= 10 && visibility < 15)
            ? DefaultTheme.NEON
            : DefaultTheme.BLUE_TEXT;
  }

  //format wind direction to Vietnamese
  String formatWindDirection(String direction) {
    String result = '';
    if (direction.toUpperCase() == 'N') {
      result = 'B';
    } else if (direction.toUpperCase() == 'NNE' ||
        direction.toUpperCase() == 'NE' ||
        direction.toUpperCase() == 'ENE') {
      result = 'ĐB';
    } else if (direction.toUpperCase() == 'E') {
      result = 'Đ';
    } else if (direction.toUpperCase() == 'ESE' ||
        direction.toUpperCase() == 'SE' ||
        direction.toUpperCase() == 'SSE') {
      result = 'ĐN';
    } else if (direction.toUpperCase() == 'S') {
      result = 'N';
    } else if (direction.toUpperCase() == 'SSW' ||
        direction.toUpperCase() == 'SW' ||
        direction.toUpperCase() == 'WSW') {
      result = 'TN';
    } else if (direction.toUpperCase() == 'W') {
      result = 'T';
    } else if (direction.toUpperCase() == 'WNW' ||
        direction.toUpperCase() == 'NW' ||
        direction.toUpperCase() == 'NNW') {
      result = 'TB';
    }
    return result;
  }
}

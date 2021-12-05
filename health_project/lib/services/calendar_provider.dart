import 'package:flutter/material.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:intl/intl.dart';

class CalendarProvider with ChangeNotifier {
  int _currentMonth =
      int.parse(DateFormat.M(Locale('vi').countryCode).format(DateTime.now()));
  int _currentYear =
      int.parse(DateFormat.y(Locale('vi').countryCode).format(DateTime.now()));

  get currentMonth => _currentMonth;
  get currentYear => _currentYear;

  void updateTime(DateTime date) {
    int month = int.parse(DateFormat.M(Locale('vi').countryCode).format(date));
    int year = int.parse(DateFormat.y(Locale('vi').countryCode).format(date));
    if (month > 0 && month <= 12) {
      _currentMonth = month;
      _currentYear = year;
      notifyListeners();
    }
  }
}

class CalendarDateProvider with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  get selectedDay => _selectedDay;
  get focusedDay => _focusedDay;

  void updateSelectedAndFocusedDay(DateTime select, DateTime focus) {
    _selectedDay = select;
    _focusedDay = focus;
    notifyListeners();
  }

  String getCurrentDayOfWeek() {
    return TimeUtil.instance.formatDateOfWeek(
        DateFormat.EEEE(Locale('en').countryCode).format(_selectedDay));
  }

  String getCurrentDate() {
    return DateFormat.d(Locale('en').countryCode).format(_selectedDay);
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  static const int HOUR_TO_MINUTE = 60;
  static const int DAY_TO_MINUTE = 1440;
  static const int WEEK_TO_MINUTE = 10800;

  const TimeUtil._privateConsrtructor();

  static final TimeUtil _instance = TimeUtil._privateConsrtructor();
  static TimeUtil get instance => _instance;

  //check color for weather widget
  bool changeWeatherWidgetByTime() {
    bool isNightOn = false;
    DateTime time = DateTime.now();
    if (time.hour > 6 && time.hour < 17) {
      isNightOn = false;
    } else {
      isNightOn = true;
    }
    return isNightOn;
  }

  //format date
  String formatNewsDetailsTime(String timeInput) {
    String result = '';
    if (timeInput.contains('T')) {
      String date = timeInput.split('T')[0];
      String time = timeInput.split('T')[1];
      result =
          '${time.split(':')[0]}:${time.split(':')[1]}, ngày ${date.split('-')[2]} tháng ${date.split('-')[1]}, năm ${date.split('-')[0]}';
    }
    return result;
  }

  //get date time in header widget
  String formatTimeHeader() {
    DateTime _now = DateTime.now();
    DateFormat _format = DateFormat('yyyy-MM-dd-EEEE');
    String _formatted = _format.format(_now);
    String _dateInWeek = formatDateOfWeek(_formatted.split('-')[3]);
    String _day = _formatted.split('-')[2];
    String _month = _formatted.split('-')[1];
    String _year = _formatted.split('-')[0];
    String _view = '$_dateInWeek, $_day tháng $_month, $_year';
    return _view;
  }

  //get birthday with format dd/MM/YYYY
  String formatBirthday(String time) {
    if (time == 'n/a') return 'n/a';
    String formattedDay = '';
    DateFormat _format = DateFormat('dd/MM/yyyy');
    formattedDay = _format.format(DateTime.parse(time));
    return formattedDay;
  }

  //format birthday text for update personal information
  String formatBirthdayForUpdate(DateTime bDay) {
    DateFormat _format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
    return _format.format(bDay).toString();
  }

  //get date in week to display today_view
  String getCurrentDateInWeek() {
    String result = '';
    DateTime _now = DateTime.now();
    DateFormat _format = DateFormat('yyyy-MM-dd-EEEE');
    String _formatted = _format.format(_now);
    result = formatDateOfWeek(_formatted.split('-')[3]);
    return result;
  }

  //get current date to display today_view
  String getCurentDate() {
    String result = '';
    DateTime _now = DateTime.now();
    String _day = DateFormat.d(Locale('en').countryCode).format(_now);
    String _month = formatMonthCalendar(
        DateFormat.M(Locale('en').countryCode).format(_now));
    result = _day + ' ' + _month;
    return result;
  }

  //get date of week string
  String formatDateOfWeek(String value) {
    String result = '';
    if (value == 'Monday') {
      result = 'Thứ hai';
    } else if (value == 'Tuesday') {
      result = 'Thứ ba';
    } else if (value == 'Wednesday') {
      result = 'Thứ tư';
    } else if (value == 'Thursday') {
      result = 'Thứ năm';
    } else if (value == 'Friday') {
      result = 'Thứ sáu';
    } else if (value.contains('Saturday')) {
      result = 'Thứ bảy';
    } else if (value == 'Sunday') {
      result = 'Chủ nhật';
    }
    return result;
  }

  //format date event in calendar (bottom sheet view)
  String formatDateEvent(String? dateString) {
    String result = '';
    if (dateString != null && dateString.contains('T')) {
      DateTime date = DateTime.parse(dateString);
      String dateInWeek = formatDateOfWeek(
          DateFormat.EEEE(Locale('en').countryCode).format(date));
      String day = dateString.split('T')[0];
      result =
          dateInWeek + ', ' + day.split('-')[2] + ' tháng ' + day.split('-')[1];
    }
    return result;
  }

  //format date activity in activity view
  String formatDateActivity(String dateString) {
    String result = '';
    if (dateString != '') {
      DateTime date = DateTime.parse(dateString);
      String dateInWeek = formatDateOfWeek(
          DateFormat.EEEE(Locale('en').countryCode).format(date));
      String day = dateString.split(' ')[0];
      result = dateInWeek +
          ', ' +
          day.split('-')[2] +
          ' tháng ' +
          day.split('-')[1] +
          ', ' +
          day.split('-')[0];
    }
    return result;
  }

  //format date of week of calendar
  String formatDateOfWeekCalendar(String value) {
    String result = '';
    if (value == 'Th 2') {
      result = 'T2';
    } else if (value == 'Th 3') {
      result = 'T3';
    } else if (value == 'Th 4') {
      result = 'T4';
    } else if (value == 'Th 5') {
      result = 'T5';
    } else if (value == 'Th 6') {
      result = 'T6';
    } else if (value.contains('Th 7')) {
      result = 'T7';
    } else if (value == 'CN') {
      result = 'CN';
    }
    return result;
  }

  //format month in header of calendar
  String formatMonthCalendar(String month) {
    String result = '';
    String prefix = 'Tháng';
    bool? isNaN = (int.tryParse(month)!.isNaN);
    if (!isNaN) {
      int? montInt = int.tryParse(month);
      if (montInt == 1) {
        result = '$prefix Một';
      } else if (montInt == 2) {
        result = '$prefix Hai';
      } else if (montInt == 3) {
        result = '$prefix Ba';
      } else if (montInt == 4) {
        result = '$prefix Tư';
      } else if (montInt == 5) {
        result = '$prefix Năm';
      } else if (montInt == 6) {
        result = '$prefix Sáu';
      } else if (montInt == 7) {
        result = '$prefix Bảy';
      } else if (montInt == 8) {
        result = '$prefix Tám';
      } else if (montInt == 9) {
        result = '$prefix Chín';
      } else if (montInt == 10) {
        result = '$prefix Mười';
      } else if (montInt == 11) {
        result = '$prefix Mười Một';
      } else if (montInt == 12) {
        result = '$prefix Mười Hai';
      }
    }
    return result;
  }

  //format last minute to view
  String formatLastMinute(int lastMinute, String date) {
    String result = '';
    if (!lastMinute.isNaN) {
      if (lastMinute <= 1) {
        //vai giay
        result = 'vài giây';
      } else if (lastMinute > 1 && lastMinute < 60) {
        //phut
        result = '$lastMinute phút';
      } else if (lastMinute >= HOUR_TO_MINUTE && lastMinute < DAY_TO_MINUTE) {
        //tieng
        result = '${lastMinute ~/ HOUR_TO_MINUTE} giờ';
      } else if (lastMinute >= DAY_TO_MINUTE && lastMinute <= WEEK_TO_MINUTE) {
        //ngay (1d,2d)
        result = '${lastMinute ~/ DAY_TO_MINUTE} ngày';
      } else if (lastMinute > WEEK_TO_MINUTE) {
        if (date.contains('T') && date.contains('-')) {
          String dateConverted = date.split('T')[0];
          String day = dateConverted.split('-')[2];
          String month = dateConverted.split('-')[1];
          result = '$day/$month';
        }
      }
    }
    return result;
  }

  //format hour get from server
  String formatHour(String date) {
    String result = '';
    if (date.contains('T')) {
      String time = date.split('T')[1].split('.')[0];
      result = time.split(':')[0] + ':' + time.split(':')[1];
    }
    return result;
  }

  //formatHourView in weather Widget
  String formatHourView(DateTime date) {
    String _formattedTime = '';
    DateFormat _format = DateFormat('HH:mm');
    _formattedTime = _format.format(DateTime.parse(date.toString()));
    return _formattedTime;
  }

  //formatHourView in weather Widget
  String formatHourView2(String date) {
    String _formattedTime = '';
    DateFormat _format = DateFormat('HH:mm');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      _formattedTime = _format.format(DateTime.parse(date.toString()));
    }
    return _formattedTime;
  }

  bool isSameDate(String date) {
    bool check = false;
    if (date.split(' ')[0] == DateTime.now().toString().split(' ')[0]) {
      check = true;
    }
    return check;
  }

  //format time to percent chart.
  double formatTimeToPercent(String time) {
    if (time == 'n/a') return 0;
    time = time.split('.')[0];
    String _formattedTime = '';
    DateFormat _format = DateFormat('HH:mm');
    _formattedTime = _format.format(DateTime.parse(time));
    double _hour = double.parse(_formattedTime.split(':')[0]);
    double _minute = double.parse(_formattedTime.split(':')[1]);
    double _hourPercent = _hour * 100 / 24;
    double _minutePercent = _minute * 100 / 60;
    double _percent = _hourPercent + (_minutePercent / 100);
    //
    return _percent;
  }

  //convert bytes from peripheral to time
  String convertBytesToLastChargedTime(Uint8List bytes) {
    String result = '';
    String year = (bytes[0] + (bytes[1] << 8)).toString();
    String month = bytes[2].toString();
    if (month.length < 2) {
      month = '0$month';
    }
    String day = bytes[3].toString();
    if (day.length < 2) {
      day = '0$day';
    }
    String hour = bytes[4].toString();
    if (hour.length < 2) {
      hour = '0$hour';
    }
    String minute = bytes[5].toString();
    if (minute.length < 2) {
      minute = '0$minute';
    }
    result = '$hour:$minute $day-$month-$year';
    // final String lastChargedTime = '$year-$month-$day $hour:$minute';
    // DateTime dt = DateTime.parse('$year-$month-$day $hour:$minute');
    return result;
  }
}

import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/peripheral_util.dart';
import 'package:health_project/commons/utils/time_util.dart';

class HealthUtil {
  const HealthUtil._privateConsrtructor();

  static final HealthUtil _instance = HealthUtil._privateConsrtructor();
  static HealthUtil get instance => _instance;

  //calculate BMI
  double calculateBMI(double weight, double height) {
    double _bmi = 0;
    _bmi = weight / ((height / 100) * (height / 100));
    return _bmi;
  }

  //get bmi type
  String getBMIType(double bmi, String gender) {
    String _type = '';
    if (gender == 'man') {
      if (bmi < 18.5) {
        _type = 'Cân nặng thấp gầy';
      } else if (bmi >= 18.5 && bmi < 25) {
        _type = 'Thể trạng bình thường';
      } else if (bmi >= 25 && bmi < 25.1) {
        _type = 'Thừa cân, nên vận động';
      } else if (bmi >= 25.1 && bmi < 30) {
        _type = 'Tiền béo phì/ béo phì';
      } else if (bmi >= 30 && bmi < 35) {
        _type = 'Béo phì độ I';
      } else if (bmi >= 35 && bmi < 40) {
        _type = 'Béo phì độ II';
      } else if (bmi >= 40) {
        _type = 'Béo phì độ III';
      }
    } else {
      if (bmi < 18.5) {
        _type = 'Cân nặng thấp gầy';
      } else if (bmi >= 18.5 && bmi < 23) {
        _type = 'Thể trạng bình thường';
      } else if (bmi >= 23 && bmi < 23.1) {
        _type = 'Thừa cân, nên vận động';
      } else if (bmi >= 23.1 && bmi < 25) {
        _type = 'Tiền béo phì/ béo phì';
      } else if (bmi >= 25 && bmi < 30) {
        _type = 'Béo phì độ I';
      } else if (bmi >= 30 && bmi < 40) {
        _type = 'Béo phì độ II';
      } else if (bmi >= 40) {
        _type = 'Béo phì độ III';
      }
    }
    return _type;
  }

  //get image asset vital sign
  String getImageVitalSign(int index) {
    String imgAsset = '';
    if (index == 1) {
      imgAsset = 'assets/images/ic-heart-rate.png';
    } else if (index == 2) {
      imgAsset = 'assets/images/ic-blood-pressure.png';
    } else if (index == 3) {
      imgAsset = 'assets/images/ic-spo2.png';
    } else if (index == 4) {
      imgAsset = 'assets/images/ic-oxy.png';
    } else if (index == 5) {
      imgAsset = 'assets/images/ic-temp.png';
    }
    return imgAsset;
  }

  //get vital sign name
  String getVitalSignName(int index) {
    String name = '';
    if (index == 1) {
      name = 'Nhịp tim';
    } else if (index == 2) {
      name = 'Huyết áp';
    } else if (index == 3) {
      name = 'SPO2';
    } else if (index == 4) {
      name = 'Oxy trong máu';
    } else if (index == 5) {
      name = 'Nhiệt độ cơ thể';
    }
    return name;
  }

  //get vital sign name by value type
  String getVitalSignNameByValueType(String valueType) {
    String name = '';
    if (valueType == VitalSignValueType.TYPE_HEART_RATE) {
      name = 'nhịp tim';
    } else if (valueType == VitalSignValueType.TYPE_BLOOD_PRESSURE) {
      name = 'huyết áp';
    } else if (valueType == VitalSignValueType.TYPE_SPO2) {
      name = 'SPO2';
    } else if (valueType == VitalSignValueType.TYPE_OXY) {
      name = 'Oxy';
    } else if (valueType == VitalSignValueType.TYPE_BODY_TEMPURATURE) {
      name = 'nhiệt độ';
    }
    return name;
  }

  String getVitalSignRoute(int index) {
    String routeName = '';
    if (index == 1) {
      routeName = Routes.HEART_RATE_VIEW;
    } else if (index == 2) {
      routeName = Routes.BLOOD_PRESSURE_VIEW;
    }
    return routeName;
  }

  String processHeartRateStatus(int _min, int _max, int _current) {
    String prefix = 'Nhịp tim được ghi nhận ';
    String result = '';
    String conclusion = '';

    //safe
    if (_min <= DefaultNumeral.HIGH_HR &&
        _min > DefaultNumeral.MIN_SAFE_HR &&
        _max <= DefaultNumeral.HIGH_HR &&
        _max > DefaultNumeral.MIN_SAFE_HR) {
      conclusion = 'Nhịp tim ở mức bình thường.';
    }
    //high
    else if (_max > DefaultNumeral.HIGH_HR &&
        _max <= DefaultNumeral.MAX_SAFE_HR) {
      conclusion =
          'Nhịp tim cao do căng thẳng hoặc vận động nhiều. Nghỉ ngơi sẽ giúp bạn tốt hơn.';
    }
    //over
    else if (_max > DefaultNumeral.MAX_SAFE_HR) {
      conclusion =
          'Nhịp tim cao bất thường. Nếu có bệnh về tim mạch, hãy liên hệ với bác sĩ chăm sóc.';
    }
    //low
    else if (_min < DefaultNumeral.MIN_SAFE_HR) {
      conclusion =
          'Nhịp tim thấp dẫn đến một số trường hợp khó thở hoặc cao huyết áp. Nghỉ ngơi sẽ giúp bạn tốt hơn.';
    }

    //
    if (_min == _max) {
      result = prefix + 'là $_max BPM.' + conclusion;
    } else {
      result = prefix + 'từ khoảng $_min - $_max BPM. ' + conclusion;
    }
    return result;
  }

  String formatTimeHistory(int index, String date) {
    String result = '';
    //sort by day
    if (index == 0) {
      result = TimeUtil.instance.formatDateEvent(date, ' ');
    }
    //sort by month
    else if (index == 1) {
      result = 'Tháng ' + date.split('-')[1] + ', năm ' + date.split('-')[0];
    }
    //sort by year
    else {
      result = 'Năm ' + date;
    }
    return result;
  }
}

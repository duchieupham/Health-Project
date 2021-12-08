import 'package:health_project/commons/routes/routes.dart';

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

  String getVitalSignRoute(int index) {
    String routeName = '';
    if (index == 1) {
      routeName = Routes.HEART_RATE_VIEW;
    } else if (index == 2) {
      routeName = Routes.BLOOD_PRESSURE_VIEW;
    }
    return routeName;
  }
}

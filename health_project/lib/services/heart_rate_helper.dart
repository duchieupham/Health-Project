import 'package:health_project/main.dart';

class HeartRateHelper {
  const HeartRateHelper._privateConstructor();

  static final HeartRateHelper _instance =
      HeartRateHelper._privateConstructor();
  static HeartRateHelper get instance => _instance;

  void initialHeartRateHelper() {
    sharedPrefs.setInt('LAST_HEART_RATE', 0);
  }

  void updateLastHeartRate(int value) {
    if (!sharedPrefs.containsKey('LAST_HEART_RATE') ||
        sharedPrefs.getInt('LAST_HEART_RATE') == null) {
      initialHeartRateHelper();
    }
    sharedPrefs.setInt('LAST_HEART_RATE', value);
  }

  int getLastHeartRate() {
    if (!sharedPrefs.containsKey('LAST_HEART_RATE') ||
        sharedPrefs.getInt('LAST_HEART_RATE') == null) {
      initialHeartRateHelper();
    }
    return sharedPrefs.getInt('LAST_HEART_RATE')!;
  }
}

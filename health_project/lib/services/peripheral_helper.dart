import 'package:health_project/main.dart';

class PeripheralHelper {
  const PeripheralHelper._privateConstructor();

  static final PeripheralHelper _instance =
      PeripheralHelper._privateConstructor();
  static PeripheralHelper get instance => _instance;

  void initialPeripheralHelper() {
    sharedPrefs.setBool('PERIPHERAL_CONNECT', false);
    sharedPrefs.setString('PERIPHERAL_ID', '');
  }

  void updatePeripheralConnect(bool check, String id) {
    if (!sharedPrefs.containsKey('PERIPHERAL_CONNECT') ||
        sharedPrefs.getBool('PERIPHERAL_CONNECT') == null) {
      initialPeripheralHelper();
    }
    sharedPrefs.setBool('PERIPHERAL_CONNECT', check);
    sharedPrefs.setString('PERIPHERAL_ID', id);
  }

  bool isPeripheralConnect() {
    if (!sharedPrefs.containsKey('PERIPHERAL_CONNECT') ||
        sharedPrefs.getBool('PERIPHERAL_CONNECT') == null) {
      initialPeripheralHelper();
    }
    return sharedPrefs.getBool('PERIPHERAL_CONNECT')!;
  }

  String getPeripheralId() {
    if (!sharedPrefs.containsKey('PERIPHERAL_ID') ||
        sharedPrefs.getString('PERIPHERAL_ID') == null) {
      initialPeripheralHelper();
    }
    return sharedPrefs.getString('PERIPHERAL_ID')!;
  }
}

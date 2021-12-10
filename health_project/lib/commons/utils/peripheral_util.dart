// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:health_project/commons/constants/theme.dart';

class PeripheralUtil {
  const PeripheralUtil._privateConstructor();

  static final PeripheralUtil _instance = PeripheralUtil._privateConstructor();
  static PeripheralUtil get instance => _instance;

  String getImageDevice(String deviceName) {
    String img = 'assets/images/devices/device-unknown.png';
    PeripheralSupport peripheralType = PeripheralSupport.UNKNOWN;
    if (deviceName.contains('Mi Smart Band 5')) {
      peripheralType = PeripheralSupport.MI_BAND_5;
    } else if (deviceName.contains('Mi Smart Band 4')) {
      peripheralType = PeripheralSupport.MI_BAND_4;
    } else if (deviceName.contains('Mi Smart Band 4')) {
      peripheralType = PeripheralSupport.MI_BAND_4;
    } else if (deviceName.contains('Mi Band 3')) {
      peripheralType = PeripheralSupport.MI_BAND_3;
    } else if (deviceName.contains('Mi Band 2')) {
      peripheralType = PeripheralSupport.MI_BAND_2;
    } else if (deviceName.contains('Amazfit')) {
      peripheralType = PeripheralSupport.AMAZFIT;
    } else if (deviceName.contains('Galaxy Fit')) {
      peripheralType = PeripheralSupport.FIT_E;
    }
    switch (peripheralType) {
      case PeripheralSupport.MI_BAND_5:
        img = 'assets/images/devices/device-miband5.png';
        break;
      case PeripheralSupport.MI_BAND_4:
        img = 'assets/images/devices/device-miband4.png';
        break;
      case PeripheralSupport.MI_BAND_3:
        img = 'assets/images/devices/device-miband3.png';
        break;
      case PeripheralSupport.MI_BAND_2:
        img = 'assets/images/devices/device-miband2.png';
        break;
      case PeripheralSupport.AMAZFIT:
        img = 'assets/images/devices/device-amazfit.png';
        break;
      case PeripheralSupport.FIT_E:
        img = 'assets/images/devices/device-fite.png';
        break;
      default:
        img = 'assets/images/devices/device-unknown.png';
        break;
    }
    return img;
  }

  String getBrandName(String deviceName) {
    String brand = '';
    if (deviceName.contains('Mi') && deviceName.contains('Band')) {
      brand = 'Xiaomi';
    } else if (deviceName.contains('Galaxy')) {
      brand = 'Samsung';
    } else if (deviceName.contains('Amazfit')) {
      brand = 'Huawei';
    } else {
      brand = 'Undefined';
    }
    return brand;
  }

  //get color of battery
  Color getBatteryColor(int percentage) {
    Color batteryColor = DefaultTheme.WHITE.withOpacity(0);
    if (percentage >= 80) {
      batteryColor = DefaultTheme.NEON;
    } else if (percentage < 80 && percentage >= 30) {
      batteryColor = DefaultTheme.BLUE_LIGHT;
    } else {
      batteryColor = DefaultTheme.RED_NEON;
    }
    return batteryColor;
  }

  //set name for vital sign type
  String getNameVitalSign(VitalSignType type) {
    String name = '';
    switch (type) {
      case VitalSignType.HEART_RATE:
        name = 'Nhịp tim';
        break;
      case VitalSignType.BLOOD_PRESSURE:
        name = 'Huyết áp';
        break;
      case VitalSignType.BODY_TEMP:
        name = 'Nhiệt độ cơ thể';
        break;
      case VitalSignType.OXY:
        name = 'Oxy trong máu';
        break;
      case VitalSignType.SPO2:
        name = 'SpO2';
        break;
      default:
        break;
    }
    return name;
  }

  //get asset link image for vital sign type
  String getImgVitalSign(VitalSignType type) {
    String asset = '';
    switch (type) {
      case VitalSignType.HEART_RATE:
        asset = 'assets/images/ic-heart-rate.png';
        break;
      case VitalSignType.BLOOD_PRESSURE:
        asset = 'assets/images/ic-blood-pressure.png';
        break;
      case VitalSignType.BODY_TEMP:
        asset = 'assets/images/ic-temp.png';
        break;
      case VitalSignType.OXY:
        asset = 'assets/images/ic-oxy.png';
        break;
      case VitalSignType.SPO2:
        asset = 'assets/images/ic-spo2.png';
        break;
      default:
        break;
    }
    return asset;
  }

  //convert bytes to activity value
  int convertBytesToActivityValue(Uint8List bytes) {
    int value = bytes[0];
    for (int i = 0; i < bytes.length; i++) {
      if (i > 0) {
        value += bytes[i] << 8;
      }
    }
    return value;
  }
}

//peripheral uuid
class PeripheralService {
  ///Declare services
  static final Guid SERVICE_DEVICE_INFORMATION =
      Guid('0000180a-0000-1000-8000-00805f9b34fb');
  static final Guid SERVICE_BATTERY =
      Guid('0000180f-0000-1000-8000-00805f9b34fb');
  static final Guid SERVICE_HUAMI =
      Guid('0000fee0-0000-1000-8000-00805f9b34fb');
  static final Guid SERVICE_HEART_RATE =
      Guid('0000180d-0000-1000-8000-00805f9b34fb');
  //
  static final Guid SERVICE_BLOOD_PRESSURE =
      Guid('00002A35-0000-1000-8000-00805f9b34fb');
  static final Guid SERVICE_BODY_TEMP =
      Guid('00002A38-0000-1000-8000-00805f9b34fb');
  //CANNOT FIND THESE SERVICES AND APPLICATION DOES NOT SUPPORT IT AT THE FIRST TIME
  //SO SET UNDEFINED GUID
  static final Guid SERVICE_SPO2 = Guid('00000000-0000-1000-8000-00805f9b34fb');
  static final Guid SERVICE_OXY = Guid('00000001-0000-1000-8000-00805f9b34fb');
  //
}

//characteristic uuid
class PeripheralCharacteristic {
  //Declare characteristic
  static final Guid C_HEART_RATE_MEASUREMENT =
      Guid("00002a37-0000-1000-8000-00805f9b34fb");
  static final Guid C_HEART_RATE_CONTROL_POINT =
      Guid("00002a39-0000-1000-8000-00805f9b34fb");
  static final Guid C_BATTERY_LEVEL =
      Guid('00002a19-0000-1000-8000-00805f9b34fb');
  static final Guid C_INFORMATION_SERIAL_NUMBER =
      Guid('00002a25-0000-1000-8000-00805f9b34fb');
  static final Guid C_INFORMATION_HARDWARE_REVISION =
      Guid('00002a27-0000-1000-8000-00805f9b34fb');
  static final Guid C_INFORMATION_SOFTWARE_REVISION =
      Guid('00002a28-0000-1000-8000-00805f9b34fb');
  static final Guid C_LAST_CHARGED_TIME =
      Guid('00000006-0000-3512-2118-0009AF100700');
  static final Guid C_HUAMI_ATT = Guid('00000007-0000-3512-2118-0009af100700');
}

//peripheral command
class PeripheralCommand {
  ///////HEART RATE WRITING MODE
  static const SLEEP = 0x0;
  static const CONTINUOUS = 0x1;
  static const MANUAL = 0x2;

///////TOGGLE
  static const TOGGLE_OFF = 0x0;
  static const TOGGLE_ON = 0x1;

////////DEVICE EVENT
  static const BUTTON_PRESSED = 0x4;

////////COMMAND
  static const START_HEART_RATE_MORNITORING = [0x15, CONTINUOUS, TOGGLE_ON];
  static const STOP_HEART_RATE_MORNITORING = [0x15, CONTINUOUS, TOGGLE_OFF];
  static const START_HEART_RATE_MEASUREMENT = [0x15, MANUAL, TOGGLE_ON];
  static const STOP_HEART_RATE_MEASUREMENT = [0x15, CONTINUOUS, TOGGLE_OFF];
}

class VitalSignValueType {
  static const TYPE_HEART_RATE = 'HEART_RATE';
  static const TYPE_BLOOD_PRESSURE = 'BLOOD_PRESSURE';
  static const TYPE_BODY_TEMPURATURE = 'BODY_TEMP';
  static const TYPE_SPO2 = 'SPO2';
  static const TYPE_OXY = 'BLOOD_OXY';
}

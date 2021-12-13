import 'dart:async';
import 'dart:typed_data';

import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/utils/peripheral_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/models/peripheral_information_dto.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:health_project/models/vital_sign_checking_dto.dart';
import 'package:health_project/services/heart_rate_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:rxdart/subjects.dart';

class PeripheralRepository {
  const PeripheralRepository();

  static List<BluetoothService>? _services;
  static BluetoothDevice? _device;
  static final heartRateController = BehaviorSubject<int>();

  Future<void> initialService(String peripheralId) async {
    try {
      if (_device == null) {
        _device = await findDeviceById(peripheralId);
      }
      await for (BluetoothDeviceState state in _device!.state) {
        if (state == BluetoothDeviceState.disconnected) {
          await _device!.connect();
          break;
        }
        if (state == BluetoothDeviceState.connected) {
          break;
        }
      }
      if (_services == null || _services!.isEmpty) {
        _services = await _device!.discoverServices();
      }
    } catch (e) {
      print('Error at initial Service: $e');
    }
  }

  disposePeripheralService() {
    _services = null;
    _device = null;
  }

  Future<PeripheralInformationDTO> getPeripheralInformation(
      String peripheralId) async {
    PeripheralInformationDTO peripherlInformationDTO = PeripheralInformationDTO(
      name: 'n/a',
      serialNumber: 'n/a',
      softwareRevision: 'n/a',
      hardwareRevision: 'n/a',
      pinPercentage: 0,
      lastChargedTime: 'n/a',
    );
    await initialService(peripheralId);
    final BluetoothService informationService = _services!.firstWhere(
        (service) =>
            service.uuid == PeripheralService.SERVICE_DEVICE_INFORMATION);
    final BluetoothService batteryService = _services!.firstWhere(
        (service) => service.uuid == PeripheralService.SERVICE_BATTERY);
    final BluetoothService huamiService = _services!.firstWhere(
        (service) => service.uuid == PeripheralService.SERVICE_HUAMI);
    //characteristic
    final BluetoothCharacteristic serialNumberCharacteristic =
        informationService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            PeripheralCharacteristic.C_INFORMATION_SERIAL_NUMBER);
    final BluetoothCharacteristic softwareRevisionCharacteristic =
        informationService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            PeripheralCharacteristic.C_INFORMATION_SOFTWARE_REVISION);
    final BluetoothCharacteristic hardwareRevisionCharacteristic =
        informationService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            PeripheralCharacteristic.C_INFORMATION_HARDWARE_REVISION);
    final BluetoothCharacteristic batteryCharacteristic =
        batteryService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid == PeripheralCharacteristic.C_BATTERY_LEVEL);
    final BluetoothCharacteristic lastChargedTimeCharacteistic =
        huamiService.characteristics.firstWhere((service) =>
            service.uuid == PeripheralCharacteristic.C_LAST_CHARGED_TIME);
    //data read
    final String serialNumber =
        String.fromCharCodes(await serialNumberCharacteristic.read());
    final String softwareRevision =
        String.fromCharCodes(await softwareRevisionCharacteristic.read());
    final String hardwareRevision =
        String.fromCharCodes(await hardwareRevisionCharacteristic.read());
    late final int pinPercentage;
    await batteryCharacteristic.read().then((data) => pinPercentage = data[0]);
    late final Uint8List chargedBytes;
    await lastChargedTimeCharacteistic.read().then((value) =>
        chargedBytes = Uint8List.fromList(value.getRange(11, 18).toList()));
    String lastChargedTime =
        TimeUtil.instance.convertBytesToLastChargedTime(chargedBytes);
    peripherlInformationDTO = PeripheralInformationDTO(
      name: _device!.name,
      serialNumber: serialNumber,
      softwareRevision: softwareRevision,
      hardwareRevision: hardwareRevision,
      pinPercentage: pinPercentage,
      lastChargedTime: lastChargedTime,
    );
    return peripherlInformationDTO;
  }

  //check _services whether contain in peripheral
  Future<List<VitalSignCheckingDTO>> checkServices(String peripheralId) async {
    final List<VitalSignCheckingDTO> listChecking = [];
    await initialService(peripheralId);
    //
    final bool heartRateChecking = _services!
        .where(
            (service) => service.uuid == PeripheralService.SERVICE_HEART_RATE)
        .isNotEmpty;
    final bool bloodPressureChecking = _services!
        .where((service) =>
            service.uuid == PeripheralService.SERVICE_BLOOD_PRESSURE)
        .isNotEmpty;
    final bool bodyTempChecking = _services!
        .where((service) => service.uuid == PeripheralService.SERVICE_BODY_TEMP)
        .isNotEmpty;
    final bool spo2Checking = _services!
        .where((service) => service.uuid == PeripheralService.SERVICE_SPO2)
        .isNotEmpty;
    final bool oxyChecking = _services!
        .where((service) => service.uuid == PeripheralService.SERVICE_OXY)
        .isNotEmpty;

    if (heartRateChecking) {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.HEART_RATE, isContained: true));
    } else {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.HEART_RATE, isContained: false));
    }
    //
    if (bloodPressureChecking) {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.BLOOD_PRESSURE, isContained: true));
    } else {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.BLOOD_PRESSURE, isContained: false));
    }
    //
    if (spo2Checking) {
      listChecking.add(
          VitalSignCheckingDTO(type: VitalSignType.SPO2, isContained: true));
    } else {
      listChecking.add(
          VitalSignCheckingDTO(type: VitalSignType.SPO2, isContained: false));
    }
    //
    if (oxyChecking) {
      listChecking.add(
          VitalSignCheckingDTO(type: VitalSignType.OXY, isContained: true));
    } else {
      listChecking.add(
          VitalSignCheckingDTO(type: VitalSignType.OXY, isContained: false));
    }
    //
    if (bodyTempChecking) {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.BODY_TEMP, isContained: true));
    } else {
      listChecking.add(VitalSignCheckingDTO(
          type: VitalSignType.BODY_TEMP, isContained: false));
    }
    return listChecking;
  }

  //get activity from peripheral
  Future<ActivityDTO> getActivity(String peripheralId, int accountId) async {
    var uuid = Uuid();
    ActivityDTO activityDTO = ActivityDTO(
      id: 'n/a',
      accountId: 0,
      step: 0,
      meter: 0,
      calorie: 0,
      dateTime: 'n/a',
    );
    try {
      await initialService(peripheralId);
      //service
      final BluetoothService huamiService = _services!.firstWhere(
          (service) => service.uuid == PeripheralService.SERVICE_HUAMI);
      //characteristic
      final BluetoothCharacteristic activity = huamiService.characteristics
          .firstWhere((characteristic) =>
              characteristic.uuid == PeripheralCharacteristic.C_HUAMI_ATT);
      //
      await activity.read().then((value) {
        //
        int stepsCount = PeripheralUtil.instance.convertBytesToActivityValue(
          Uint8List.fromList(
            value.getRange(1, 5).toList(),
          ),
        );
        //
        int meters = PeripheralUtil.instance.convertBytesToActivityValue(
          Uint8List.fromList(
            value.getRange(5, 9).toList(),
          ),
        );
        //
        int calories = PeripheralUtil.instance.convertBytesToActivityValue(
          Uint8List.fromList(
            value.getRange(9, 13).toList(),
          ),
        );
        //
        activityDTO = ActivityDTO(
          id: uuid.v1(),
          accountId: accountId,
          step: stepsCount,
          meter: meters,
          calorie: calories,
          dateTime: DateTime.now().toString(),
        );
      });
    } catch (e) {
      print('Error at get Activity: $e');
    }
    return activityDTO;
  }

  //find peripheral by UUID
  //Notice: Function only find peripheral that paired/connected with user's phone before.
  //It cannot find others, so if user try to connect with other peripheral that's not pair
  //Function cannot find device to keep connect.
  Future<BluetoothDevice?> findDeviceById(String peripheralId) async {
    BluetoothDevice? device;
    try {
      FlutterBlue.instance.startScan(
          timeout: Duration(seconds: DefaultNumeral.TIME_OUT_SCANNING));
      //USING AWAIT FOR AND CHECK CONDITION IN LISNTEN()
      //THEN BREAK LISTEN()
      //If only using x.listen(), it cannot break out.
      await for (List<ScanResult> rs in FlutterBlue.instance.scanResults) {
        bool check = rs
            .where((element) => element.device.id.toString() == peripheralId)
            .isNotEmpty;
        if (check) {
          await FlutterBlue.instance.stopScan();
          device = rs
              .firstWhere(
                  (element) => element.device.id.toString() == peripheralId)
              .device;
          break;
        }
      }
    } catch (e) {
      print('error at findDeviceById: $e');
      await FlutterBlue.instance.stopScan();
    }
    return device;
  }

  //following heart rate. This is a function about tracking heart rate
  //from time to time.

  //Get heart rate. This function turn sensor on and set notify TURE for value of heart rate sensor. Not return any value.
  Future<void> getHeartRate(String peripheralId) async {
    await initialService(peripheralId);
    final BluetoothService heartRateService = _services!.firstWhere(
        (service) => service.uuid == PeripheralService.SERVICE_HEART_RATE);
    //characteristics
    //control point to kick heart rate sensor ON
    final BluetoothCharacteristic heartRateControlPoint =
        heartRateService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            PeripheralCharacteristic.C_HEART_RATE_CONTROL_POINT);
    //measurement to listen values return
    final BluetoothCharacteristic heartRateMeasurement =
        heartRateService.characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            PeripheralCharacteristic.C_HEART_RATE_MEASUREMENT);
    //

    await heartRateControlPoint
        .write(PeripheralCommand.START_HEART_RATE_MORNITORING);
    heartRateController.sink.add(0);
    await heartRateMeasurement.setNotifyValue(true);
    int count = 0;
    heartRateMeasurement.value.listen((values) {
      if (values.isNotEmpty) {
        if (count == 0) {
          HeartRateHelper.instance.updateLastHeartRate(values[1]);
        }
        count++;
        //Because the last value is the old value tracking,
        // Checking the new value whether matched or not.
        if (values[1] != HeartRateHelper.instance.getLastHeartRate()) {
          heartRateController.sink.add(values[1]);
        }
      }
    });
  }
}

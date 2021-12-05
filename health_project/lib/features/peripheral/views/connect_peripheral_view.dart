import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/peripheral_util.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/services/peripheral_connecting_provider.dart';
import 'package:health_project/services/peripheral_helper.dart';
import 'package:rive/rive.dart' as rive;
import 'package:provider/provider.dart';

class ConnectPeripheralView extends StatefulWidget {
  const ConnectPeripheralView();

  @override
  State<StatefulWidget> createState() => _ConnectPeripheralView();
}

class _ConnectPeripheralView extends State<ConnectPeripheralView> {
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  static const ANIMATION_DEFAULT_STATE = 'To select device';
  static const STATE_MACHINE_ANIMATION = 'Connect device st. machine';
  bool _isRiveInit = false;

  @override
  _ConnectPeripheralView();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }

  void _scanDevice(BluetoothState? state) {
    if (state == BluetoothState.on)
      FlutterBlue.instance
          .startScan(
              timeout: Duration(seconds: DefaultNumeral.TIME_OUT_SCANNING))
          .catchError((e) {
        if (e.toString().contains('Another scan is already in progress')) {
          FlutterBlue.instance.stopScan();
        }
      });
  }

//initial of animation
  void _onRiveInit(rive.Artboard artboard) {
    if (!_isRiveInit) {
      _riveController = rive.StateMachineController.fromArtboard(
          artboard, STATE_MACHINE_ANIMATION)!;
      artboard.addController(_riveController);
      _isRiveInit = true;
    }
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action = _riveController.findInput<bool>('do init') as rive.SMITrigger;
    _action.fire();
  }

  void _doConnectPeripheralAnimation() {
    _action = _riveController.findInput<bool>('do connect') as rive.SMITrigger;
    _action.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            _scanDevice(snapshot.data);
            return Stack(
              children: [
                Positioned(
                  child: Opacity(
                    opacity: (snapshot.data == BluetoothState.on) ? 1 : 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 2 / 3,
                      child: rive.RiveAnimation.asset(
                        'assets/rives/logo.riv',
                        fit: BoxFit.fitWidth,
                        antialiasing: true,
                        animations: [ANIMATION_DEFAULT_STATE],
                        onInit: _onRiveInit,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: (snapshot.data == BluetoothState.on ||
                            snapshot.data == BluetoothState.turningOn)
                        ? _buildAvailableBluetoothWidget()
                        : _buildDisableBluetoothWidget(),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: StreamBuilder<bool>(
                    stream: FlutterBlue.instance.isScanning,
                    initialData: false,
                    builder: (c, snapshotScanning) {
                      if (snapshotScanning.data! &&
                          (snapshot.data == BluetoothState.on ||
                              snapshot.data == BluetoothState.turningOn)) {
                        return TweenAnimationBuilder<double>(
                          duration: Duration(seconds: 10),
                          tween: Tween(begin: 10.0, end: 0.0),
                          builder: (context, value, child) {
                            return Container(
                              height: 40,
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Còn ${value.toInt() + 1} giây quét lại',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        );
                      } else if (!snapshotScanning.data! &&
                          (snapshot.data == BluetoothState.on ||
                              snapshot.data == BluetoothState.turningOn)) {
                        return DefaultTheme.buildButtonBox(
                          onTap: () async {
                            await FlutterBlue.instance.stopScan();
                            await FlutterBlue.instance.startScan(
                              timeout: Duration(seconds: 10),
                            );
                          },
                          borderRadius: 20,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.only(left: 10, right: 20),
                            decoration:
                                DefaultTheme.cardDecorationWithOpacity(context),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic-reload.png',
                                  width: 30,
                                  height: 30,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    'Quét lại',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SubHeader(
                    title: '',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvailableBluetoothWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 2,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (c, snapshot) {
              return ListView(
                children: snapshot.data!.map((r) {
                  return (r.device.name != '')
                      ? _buildDeviceWidget(r, r.device.name, r.device.id)
                      : Container();
                }).toList(),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Chọn thiết bị',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 40, right: 40, bottom: 50, top: 10),
          child: Text(
            'Danh sách thiết bị khả dụng gần bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceWidget(
    ScanResult result,
    String deviceName,
    DeviceIdentifier id,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: DefaultTheme.buildButtonBox(
        borderRadius: 12,
        onTap: () {
          _showConfirmBox(result);
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: DefaultTheme.cardDecorationWithOpacity(context),
          child:
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(
                      PeripheralUtil.instance.getImageDevice(deviceName),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 140,
                child: Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          //     Text('Device ID: ${id.toString()}'),
          //     Padding(padding: EdgeInsets.only(bottom: 10)),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildDisableBluetoothWidget() {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            height: MediaQuery.of(context).size.height - 500,
            child: Image.asset('assets/images/ic-bluetooth.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Bluetooth không khả dụng',
            style: TextStyle(
              color: DefaultTheme.BLACK,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
          child: Text(
            'Bật kết nối bluetooth trong cài đặt để thực hiện ghép nối',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],
    );
  }

  void _showConfirmBox(
    ScanResult result,
  ) {
    final double _borderRadius = 20;
    final double _width = MediaQuery.of(context).size.width - 40;
    final double _buttonConfirmWidth = (_width - 40) / 2 - 0.25;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  height: 350,
                  width: _width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                  ),
                  child: Card(
                    color: Theme.of(context).cardColor.withOpacity(0),
                    elevation: 0,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Xác nhận kết nối',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Đảm bảo những lưu ý dưới đây để hệ thống ghi nhận nhịp tim của bạn một cách ổn định nhất:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        //
                        Text(
                          'Hệ thống chỉ kết nối và duy trì với 1 thiết bị duy nhất trong 1 phiên đăng nhập.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        Text(
                          'Đảm bảo rằng bạn đã cấp quyền truy cập dữ liệu bên thứ ba của thiết bị.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Spacer(),
                        Divider(
                          height: 0.5,
                          color: Theme.of(context).accentColor,
                        ),
                        Row(
                          children: [
                            //
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: _buttonConfirmWidth,
                                height: 60,
                                padding: EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                child: Text(
                                  'Huỷ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: DefaultTheme.BLUE_TEXT,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 0.5,
                              height: 60,
                              color: Theme.of(context).accentColor,
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.of(dialogContext).pop();
                                _doConnectPeripheralAnimation();
                                await result.device.connect();
                                await FlutterBlue.instance.stopScan();
                                PeripheralHelper.instance
                                    .updatePeripheralConnect(
                                        true, result.device.id.toString());
                                Future.delayed(Duration(seconds: 1))
                                    .then((value) {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.PERIPHERAL_INFOR_VIEW);
                                });
                              },
                              child: Container(
                                width: _buttonConfirmWidth,
                                height: 60,
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.center,
                                child: Text(
                                  'Xác nhận',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: DefaultTheme.BLUE_TEXT,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

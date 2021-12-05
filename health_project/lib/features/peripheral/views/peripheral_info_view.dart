import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/peripheral_util.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:health_project/features/peripheral/events/peripheral_event.dart';
import 'package:health_project/features/peripheral/states/peripheral_state.dart';
import 'package:health_project/models/peripheral_information_dto.dart';
import 'package:health_project/models/vital_sign_checking_dto.dart';
import 'package:health_project/services/peripheral_connecting_provider.dart';
import 'package:health_project/services/peripheral_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class PeripheralInfoView extends StatefulWidget {
  const PeripheralInfoView();

  @override
  State<StatefulWidget> createState() => _PeripheralInfoView();
}

class _PeripheralInfoView extends State<PeripheralInfoView>
    with SingleTickerProviderStateMixin {
  late final PeripheralBLoc _peripheralBLoc;
  PeripheralInformationDTO _peripherlInformationDTO = PeripheralInformationDTO(
    name: 'n/a',
    serialNumber: 'n/a',
    softwareRevision: 'n/a',
    hardwareRevision: 'n/a',
    pinPercentage: 0,
    lastChargedTime: 'n/a',
  );
  List<VitalSignCheckingDTO> _listVitalSignChecking = [];

  final double _marginEdge = 10;

  //check PeripheralEventGet is called or not
  int _isPeripheralInfoGet = 0;

  //animation for pin percentage
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  _PeripheralInfoView();

  @override
  void initState() {
    super.initState();
    _peripheralBLoc = BlocProvider.of(context);
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.on && _isPeripheralInfoGet == 0) {
        _getPeripheralInfoEvent();
        _isPeripheralInfoGet++;
      }
    });
    //animation for battery
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            //
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 4 * 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-device.png'),
                  ),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 4 * 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 40,
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
                width: MediaQuery.of(context).size.width,
                child: BlocConsumer<PeripheralBLoc, PeripheralState>(
                  listener: (context, state) {
                    if (state is PeripheralInfoFailedState) {
                      _isPeripheralInfoGet = 0;
                    }
                    if (state is PeripheralInfoSuccessState) {
                      _peripherlInformationDTO = state.peripheralInformationDTO;
                      _listVitalSignChecking = state.listVitalSignChecking;
                      Provider.of<PeripheralConnectingProvider>(context,
                              listen: false)
                          .updatePeripheralConnect(true);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 40),
                          width: MediaQuery.of(context).size.width - 40,
                          padding: EdgeInsets.only(left: 20),
                          height: 80,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE,
                                  border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.25,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      PeripheralUtil.instance.getImageDevice(
                                          _peripherlInformationDTO.name),
                                    ),
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: _peripherlInformationDTO.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '\nHãng: ${PeripheralUtil.instance.getBrandName(_peripherlInformationDTO.name)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: [
                              _buildBoxWidget(
                                width: MediaQuery.of(context).size.width,
                                height: null,
                                marginLeft: _marginEdge,
                                marginRight: _marginEdge,
                                marginTop: 30,
                                padding: 20,
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Trạng thái:',
                                      ),
                                      WidgetSpan(
                                        child: StreamBuilder<BluetoothState>(
                                          stream: FlutterBlue.instance.state,
                                          initialData: BluetoothState.unknown,
                                          builder: (c, snapshot) {
                                            // if (snapshot.data ==
                                            //         BluetoothState.on &&
                                            //     _isPeripheralInfoGet == 0) {
                                            //   print('call event in widget');
                                            //   _getPeripheralInfoEvent();
                                            //   _isPeripheralInfoGet++;
                                            // }
                                            return Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                (snapshot.data ==
                                                        BluetoothState.on)
                                                    ? 'Đang kết nối'
                                                    : 'Ngắt kết nối',
                                                style: TextStyle(
                                                  color: (snapshot.data ==
                                                          BluetoothState.on)
                                                      ? DefaultTheme.BLUE_TEXT
                                                      : DefaultTheme
                                                          .RED_CALENDAR,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBoxWidget(
                                    width: MediaQuery.of(context).size.width *
                                            1 /
                                            3 -
                                        15,
                                    height: MediaQuery.of(context).size.width *
                                        2 /
                                        3,
                                    marginLeft: _marginEdge,
                                    marginRight: _marginEdge / 2,
                                    marginTop: _marginEdge,
                                    padding: 20,
                                    alignment: Alignment.center,
                                    child: _buildPinPercentageWidget(
                                      width: MediaQuery.of(context).size.width *
                                              1 /
                                              3 -
                                          55,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              2 /
                                              3,
                                      pinPercentage: _peripherlInformationDTO
                                          .pinPercentage,
                                    ),
                                  ),
                                  _buildBoxWidget(
                                    width: MediaQuery.of(context).size.width *
                                            2 /
                                            3 -
                                        15,
                                    height: MediaQuery.of(context).size.width *
                                        2 /
                                        3,
                                    marginLeft: _marginEdge / 2,
                                    marginRight: _marginEdge,
                                    marginTop: _marginEdge,
                                    padding: 20,
                                    alignment: Alignment.center,
                                    child: _buildInformationWidget(
                                      serial:
                                          _peripherlInformationDTO.serialNumber,
                                      hardwareRevision: _peripherlInformationDTO
                                          .hardwareRevision,
                                      softwareRevision: _peripherlInformationDTO
                                          .softwareRevision,
                                      lastChargedTime: _peripherlInformationDTO
                                          .lastChargedTime,
                                    ),
                                  ),
                                ],
                              ),
                              //
                              _buildBoxWidget(
                                width: MediaQuery.of(context).size.width,
                                height: null,
                                marginLeft: _marginEdge,
                                marginRight: _marginEdge,
                                marginTop: 10,
                                padding: 20,
                                alignment: Alignment.center,
                                child: _buildAvailableService(),
                              ),
                            ],
                          ),
                        ),
                        //
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 30, left: 30, right: 30, top: 10),
                          child: DefaultTheme.buildButtonBox(
                            onTap: () {
                              _peripheralBLoc.add(
                                PeripheralEventDisconnect(
                                  id: PeripheralHelper.instance
                                      .getPeripheralId(),
                                ),
                              );
                              PeripheralHelper.instance
                                  .initialPeripheralHelper();
                              Provider.of<PeripheralConnectingProvider>(context,
                                      listen: false)
                                  .updatePeripheralConnect(false);
                              Navigator.of(context).pop();
                            },
                            borderRadius: 12,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration:
                                  DefaultTheme.cardDecorationWithOpacity(
                                      context),
                              alignment: Alignment.center,
                              child: Text(
                                'Huỷ kết nối',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: DefaultTheme.RED_TEXT,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              child: SubHeader(title: ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Thiết bị hỗ trợ các sinh hiệu:',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemCount: _listVitalSignChecking.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  //
                  Image.asset(
                    PeripheralUtil.instance
                        .getImgVitalSign(_listVitalSignChecking[index].type),
                    width: 30,
                    height: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Text(
                    PeripheralUtil.instance
                        .getNameVitalSign(_listVitalSignChecking[index].type),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                  Text(
                    (_listVitalSignChecking[index].isContained)
                        ? 'Có'
                        : 'Không',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: DefaultTheme.GREY_TOP_TAB_BAR,
              height: 0.5,
            );
          },
        ),
      ],
    );
  }

  Widget _buildInformationWidget({
    required String serial,
    required String softwareRevision,
    required String hardwareRevision,
    required String lastChargedTime,
  }) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).hintColor,
        ),
        children: [
          TextSpan(
            text: 'Số Serial thiết bị: ',
          ),
          TextSpan(
            text: '\n$serial',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '\n\nPhiên bản phần cứng: ',
          ),
          TextSpan(
            text: '\n$hardwareRevision',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '\n\nPhiên bản phần mềm: ',
          ),
          TextSpan(
            text: '\n$softwareRevision',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '\n\nSạc lần cuối: ',
          ),
          TextSpan(
            text: '\n$lastChargedTime',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinPercentageWidget({
    required double width,
    required double height,
    required int pinPercentage,
  }) {
    final double paddingVertical = 50;
    height = height - (paddingVertical * 2);
    final double pinHeight = pinPercentage * height / 100;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final Tween<double> _rotationTween = Tween(begin: 0, end: pinHeight);
        _animation = _rotationTween.animate(_animationController);
        if (pinHeight != 0) {
          _animation.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.stop();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
          _animationController.forward();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: paddingVertical / 2,
              child: Container(
                height: _animation.value,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      PeripheralUtil.instance
                          .getBatteryColor(_animation.value * 100 ~/ height),
                      DefaultTheme.WHITE.withOpacity(0.0)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: (paddingVertical / 2) + _animation.value + 5,
              child: Text(
                '${_animation.value * 100 ~/ height}%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Pin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBoxWidget({
    required double width,
    required double? height,
    required double marginLeft,
    required double marginRight,
    required double marginTop,
    required double padding,
    required Alignment alignment,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      margin:
          EdgeInsets.only(left: marginLeft, right: marginRight, top: marginTop),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          width: 0.25,
        ),
      ),
      child: child,
    );
  }

  void _getPeripheralInfoEvent() {
    _peripheralBLoc.add(
        PeripheralEventGet(id: PeripheralHelper.instance.getPeripheralId()));
  }
}

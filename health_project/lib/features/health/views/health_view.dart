import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/routes/routes.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/commons/utils/health_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/commons/widgets/title_widget.dart';
import 'package:health_project/commons/widgets/weight_ruler_painter.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/features/health/views/bmi_update_view.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:health_project/services/peripheral_connecting_provider.dart';
import 'package:health_project/services/peripheral_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthView extends StatelessWidget {
  static late final ActivityBloc _activityBloc;
  static late final BMIBloc _bmiBloc;
  static bool _isInitial = false;
  static BMIDTO _bmiDTO = BMIDTO(
    gender: 'n/a',
    height: 0,
    weight: 0,
    id: 0,
  );
  static ActivityDTO _activityDTO = ActivityDTO(
    id: '',
    accountId: 0,
    calorie: 0,
    meter: 0,
    step: 0,
    dateTime: '',
  );

  const HealthView(Key key) : super(key: key);

  void initialServices(BuildContext context) {
    if (!_isInitial) {
      _activityBloc = BlocProvider.of(context);
      _bmiBloc = BlocProvider.of(context);
      _getEvents();
    }
    _isInitial = true;
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _getEvents();
      },
      child: ListView(
        key: PageStorageKey('HEALTH_LIST'),
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          //check peripheral wheter connected or not
          Consumer<PeripheralConnectingProvider>(
            builder: (context, peripheral, child) {
              if (peripheral.isPeripheralConnected) {
                _getEvents();
              }
              return (peripheral.isPeripheralConnected)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //shortcut widget
                        TitleWidget(
                          title: 'Phím tắt',
                          buttonTitle: '',
                          color: DefaultTheme.BLUE_TEXT,
                          subButton: false,
                          onTap: null,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: DefaultTheme.cardDecoration(context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildButtonShorcut(
                                    context: context,
                                    text: 'Xem thông tin thiết bị',
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          Routes.PERIPHERAL_INFOR_VIEW);
                                    }),
                                Divider(
                                  height: 0.5,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                                _buildButtonShorcut(
                                    context: context,
                                    text: 'Đo nhịp tim',
                                    onTap: () {}),
                                Divider(
                                  height: 0.5,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                                _buildButtonShorcut(
                                    context: context,
                                    text: 'Theo dõi nhịp tim',
                                    onTap: () {}),
                              ],
                            )),
                        //activity widget
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: TitleWidget(
                            title: 'Hoạt động thể chất',
                            buttonTitle: 'Xem thêm',
                            color: DefaultTheme.DARK_PURPLE,
                            subButton: true,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.ACTIVITY_VIEW);
                            },
                          ),
                        ),
                        _buildActivityWidget(context),
                      ],
                    )
                  : _buildConnectPButton(context);
            },
          ),

          //build BMI widget
          _buildBMIWidget(context),

          //build vital sign widget
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: TitleWidget(
              title: 'Sinh hiệu',
              buttonTitle: '',
              color: DefaultTheme.RED_CALENDAR,
              subButton: false,
              onTap: null,
            ),
          ),
          _buildVitalSignWidget(context),

          //build footer padding
          Padding(padding: EdgeInsets.only(bottom: 100))
        ],
      ),
    );
  }

  Widget _buildVitalSignWidget(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(
        5,
        (index) {
          return _buildVitalSignComponent(context, index + 1);
        },
      ),
    );
  }

  Widget _buildVitalSignComponent(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        right: (index % 3 == 1 || index % 3 == 2) ? 5 : 0,
        left: (index % 3 == 0 || index % 3 == 2) ? 5 : 0,
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: DefaultTheme.cardDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            HealthUtil.instance.getImageVitalSign(index),
            width: 40,
            height: 40,
          ),
          Text(
            HealthUtil.instance.getVitalSignName(index),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIWidget(BuildContext context) {
    double widgetHeight = MediaQuery.of(context).size.width / 2;
    return BlocBuilder<BMIBloc, HealthState>(
      builder: (context, state) {
        double _bmiCalculated = 0;
        if (state is BMILoadSuccessState) {
          _bmiDTO = state.dto;
          _bmiCalculated =
              HealthUtil.instance.calculateBMI(_bmiDTO.weight, _bmiDTO.height);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: TitleWidget(
                title: 'Chỉ số khối cơ thể',
                buttonTitle: 'Cập nhật',
                color: DefaultTheme.NEON,
                subButton: true,
                onTap: () {
                  //navigate to update bmi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BMIUpdateView(
                        bmiDTO: _bmiDTO,
                      ),
                    ),
                  ).then((_) {
                    _getEvents();
                  });
                },
              ),
            ),
            //
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 2 / 3 - 15,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(20),
                  height: widgetHeight,
                  decoration: DefaultTheme.cardDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 2 / 3 - 15,
                        alignment: Alignment.center,
                        child: Text(
                          _bmiCalculated.roundToDouble().toString(),
                          style: TextStyle(
                            color: DefaultTheme.SUCCESS_STATUS,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 2 / 3 - 15,
                        alignment: Alignment.center,
                        child: Text(
                          HealthUtil.instance
                              .getBMIType(_bmiCalculated, _bmiDTO.gender),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: DefaultTheme.PURPLE_NEON,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1 / 3 - 15,
                      height: widgetHeight * 1 / 3,
                      decoration: BoxDecoration(
                        color: (_bmiDTO.gender == 'man')
                            ? DefaultTheme.BLUE_LIGHT.withOpacity(0.5)
                            : DefaultTheme.RED_NEON.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                            DefaultNumeral.DEFAULT_BORDER_RAD),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ArrayValidator.instance.formatGender(_bmiDTO.gender),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: (_bmiDTO.gender == 'man')
                              ? DefaultTheme.WINTER_COLOR
                              : DefaultTheme.DARK_PINK,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1 / 3 - 15,
                      height: widgetHeight * 2 / 3 - 10,
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      decoration: DefaultTheme.cardDecoration(context),
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).hintColor,
                          ),
                          children: [
                            TextSpan(
                              text: _bmiDTO.height.toInt().toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' cm',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 100,
              decoration: DefaultTheme.cardDecoration(context),
              child: CustomPaint(
                painter: WeightRulerPainter(
                  context: context,
                  width: MediaQuery.of(context).size.width - 60,
                  height: 100,
                  weight: _bmiDTO.weight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityWidget(BuildContext context) {
    return BlocBuilder<ActivityBloc, HealthState>(
      builder: (context, state) {
        if (state is ActivityPSuccessState) {
          _activityDTO = state.dto;
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 25),
          decoration: DefaultTheme.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'Bước chân\n',
                        ),
                        WidgetSpan(
                          child: Image.asset(
                            'assets/images/ic-step-count.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: '${_activityDTO.step}',
                          style: TextStyle(
                            color: DefaultTheme.PURPLE_NEON,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'Quảng đường\n',
                        ),
                        WidgetSpan(
                          child: Image.asset(
                            'assets/images/ic-meter.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: '${_activityDTO.meter}',
                          style: TextStyle(
                            color: DefaultTheme.SUCCESS_STATUS,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' m',
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'Năng lượng\n',
                        ),
                        WidgetSpan(
                          child: Image.asset(
                            'assets/images/ic-kcal.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: '${_activityDTO.calorie}',
                          style: TextStyle(
                            color: DefaultTheme.ORANGE,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' kcal',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.centerRight,
                child: Text(
                  'Cập nhật lúc: ${TimeUtil.instance.formatHourView2(_activityDTO.dateTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectPButton(BuildContext context) {
    return DefaultTheme.buildButtonBox(
      borderRadius: 12,
      onTap: () {
        Navigator.of(context).pushNamed(Routes.INTRO_CONNECT_VIEW);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(20),
        decoration: DefaultTheme.cardDecorationWithOpacity(context),
        child: Row(
          children: [
            //
            ClipOval(
              child: Image.asset(
                'assets/images/ic-device.png',
                width: 40,
                height: 40,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width - 110,
              child: RichText(
                textAlign: TextAlign.left,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).hintColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Kết nối thiết bị đeo\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Ứng dụng ghi nhận nhịp tim và các hoạt động thể chất bằng thiêt bị đeo.',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonShorcut({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: DefaultTheme.BLUE_TEXT,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  //get APIs from server
  Future<void> _getEvents() async {
    if (PeripheralHelper.instance.isPeripheralConnect()) {
      _activityBloc.add(
        ActivityEventGet(
          peripheralId: PeripheralHelper.instance.getPeripheralId(),
          accountId: AuthenticateHelper.instance.getAccountId(),
        ),
      );
    }
    _bmiBloc.add(
      BMIEventGet(
        accountId: AuthenticateHelper.instance.getAccountId(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/peripheral_util.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/features/health/views/heart_rate_measure_view.dart';
import 'package:health_project/models/vital_sign_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:provider/provider.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/heart_rate_chart_painter.dart';
import 'package:health_project/services/tab_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class HeartRateView extends StatefulWidget {
  const HeartRateView();

  @override
  State<StatefulWidget> createState() => _HeartRateView();
}

class _HeartRateView extends State<HeartRateView>
    with SingleTickerProviderStateMixin {
  //
  late final HeartRateBloc _heartRateBloc;
  late AnimationController _animationController;
  late Animation<int> _animation;
  final List<int> _heartValues = [];
  final List<String> _timeValues = [];
  late ChartType _chartType;

  _HeartRateView();

  @override
  void initState() {
    super.initState();
    _heartRateBloc = BlocProvider.of(context);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    if (Provider.of<TabProvider>(context, listen: false).tabIndex == 0) {
      _chartType = ChartType.HOUR;
      _getEvents(ChartType.HOUR);
    } else {
      _chartType = ChartType.DAY;
      _getEvents(ChartType.DAY);
    }
  }

  @override
  void dispose() {
    _heartValues.clear();
    _timeValues.clear();
    _animationController.dispose();
    super.dispose();
  }

  void _getEvents(ChartType chartType) {
    VitalSignDTO dto = VitalSignDTO(
      id: 'n/a',
      accountId: AuthenticateHelper.instance.getAccountId(),
      value1: 0,
      value2: 0,
      time: DateTime.now().toString(),
      type: VitalSignValueType.TYPE_HEART_RATE,
    );
    _heartRateBloc.add(HeartRateGetListEvent(dto: dto, chartType: chartType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            Stack(
              children: [
                SubHeader(title: 'Nhịp tim'),
                Positioned(
                  top: 10,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      _buildHeartRateMeasuringView();
                    },
                    child: Container(
                      width: 120,
                      height: 60,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Đo',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: DefaultTheme.BLUE_TEXT,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<HeartRateBloc, HealthState>(
                listener: (context, state) {
                  if (state is HeartRateSuccessfulListState) {
                    _heartValues.clear();
                    _timeValues.clear();
                    if (state.list.isNotEmpty) {
                      for (VitalSignDTO dto in state.list) {
                        _heartValues.add(dto.value1);
                        _timeValues
                            .add(TimeUtil.instance.formatHourView2(dto.time));
                      }
                    }
                  }
                },
                buildWhen: (previous, current) =>
                    previous != current &&
                    current is HeartRateSuccessfulListState,
                builder: (context, state) {
                  return ListView(
                    children: [
                      _buildInformationTab(),
                      Container(
                        margin: EdgeInsets.only(
                            right: DefaultNumeral.DEFAULT_MARGIN,
                            left: DefaultNumeral.DEFAULT_MARGIN,
                            top: 30),
                        width: MediaQuery.of(context).size.width -
                            (DefaultNumeral.DEFAULT_MARGIN * 2),
                        height: MediaQuery.of(context).size.width -
                            (DefaultNumeral.DEFAULT_MARGIN * 2),
                        //  color: Colors.red,
                        padding: EdgeInsets.only(left: 10),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            if (_heartValues.isNotEmpty &&
                                _timeValues.isNotEmpty) {
                              final IntTween _rotationTween =
                                  IntTween(begin: 1, end: _heartValues.length);
                              _animation =
                                  _rotationTween.animate(_animationController)
                                    ..addStatusListener((status) {
                                      if (status == AnimationStatus.completed) {
                                        _animationController.stop();
                                      } else if (status ==
                                          AnimationStatus.dismissed) {
                                        _animationController.forward();
                                      }
                                    });
                              _animationController.forward();
                            }
                            return Consumer<TabProvider>(
                              builder: (context, tab, child) {
                                return CustomPaint(
                                  painter: HeartRateChartPainter(
                                    context: context,
                                    edge: MediaQuery.of(context).size.width -
                                        (DefaultNumeral.DEFAULT_MARGIN * 2),
                                    currentTime: (_timeValues.isNotEmpty)
                                        ? _timeValues.last
                                        : DateTime.now().toString(),
                                    heartValues: _heartValues,
                                    timeValues: _timeValues,
                                    type: (tab.tabIndex == 0)
                                        //  type: (_chartType == ChartType.HOUR)
                                        ? ChartType.HOUR
                                        : ChartType.DAY,
                                    valueLength:
                                        (_chartType == ChartType.HOUR &&
                                                _heartValues.isNotEmpty &&
                                                _timeValues.isNotEmpty)
                                            ? _animation.value
                                            : _heartValues.length,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      (_heartValues.isNotEmpty && _timeValues.isNotEmpty)
                          ? _buildLastHeartRate(
                              _heartValues.last, _timeValues.last)
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastHeartRate(int lastValue, String lastTime) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
      padding: EdgeInsets.all(20),
      decoration: DefaultTheme.cardDecoration(context),
      child: Row(
        children: [
          Text(
            'Nhịp tim đo gần nhất: ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Spacer(),
          Text(
            '$lastValue',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).indicatorColor,
            ),
          ),
          Text('\tBPM - $lastTime'),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    int _max = 0, _min = 0;
    String currentHour =
        TimeUtil.instance.getHourToView(DateTime.now().toString());
    String nextHour =
        TimeUtil.instance.getNextHourToView(DateTime.now().toString());
    if (_heartValues.isNotEmpty && _timeValues.isNotEmpty) {
      _max = _heartValues.reduce((curr, next) => curr > next ? curr : next);
      _min = _heartValues.reduce((curr, next) => curr < next ? curr : next);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (_timeValues.isNotEmpty)
              ? RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).hintColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Phạm vi\n'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).shadowColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '$_min - $_max',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '\tBPM\n',
                        style: TextStyle(
                          color: Theme.of(context).shadowColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: (_chartType == ChartType.HOUR)
                            ? 'Từ $currentHour - $nextHour'
                            : '${TimeUtil.instance.formatTimeHeader()}',
                      ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    (_chartType == ChartType.HOUR)
                        ? 'Không có dữ liệu\nTừ $currentHour - $nextHour'
                        : 'Không có dữ liệu\n${TimeUtil.instance.formatTimeHeader()}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
          Container(
            width: 115,
            height: 30,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).cardColor,
            ),
            child: Consumer<TabProvider>(
              builder: (context, tab, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        tab.updateTabIndex(0);
                        getEventsByTabIndex(0);
                      },
                      child: Container(
                        width: 50,
                        alignment: Alignment.center,
                        decoration: (tab.tabIndex == 0) ? _selectedBox() : null,
                        child: Text(
                          'Giờ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    InkWell(
                      onTap: () {
                        tab.updateTabIndex(1);
                        getEventsByTabIndex(1);
                      },
                      child: Container(
                        width: 50,
                        alignment: Alignment.center,
                        decoration: (tab.tabIndex == 1) ? _selectedBox() : null,
                        child: Text(
                          'Ngày',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildHeartRateMeasuringView() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return HeartRateMeasureView();
        }).then((value) {
      if (value != null && value != 0) {
        var uuid = Uuid();
        VitalSignDTO dto = VitalSignDTO(
            id: uuid.v1(),
            accountId: AuthenticateHelper.instance.getAccountId(),
            value1: value,
            value2: 0,
            time: DateTime.now().toString(),
            type: VitalSignValueType.TYPE_HEART_RATE);
        _heartRateBloc
            .add(HeartRateAddValueEvent(dto: dto, chartType: _chartType));
      }
    });
  }

  void getEventsByTabIndex(int index) {
    _heartValues.clear();
    _timeValues.clear();
    if (index == 0) {
      _chartType = ChartType.HOUR;
      _getEvents(ChartType.HOUR);
    } else {
      _chartType = ChartType.DAY;
      _getEvents(ChartType.DAY);
    }
  }

  BoxDecoration _selectedBox() {
    return BoxDecoration(
      color: Theme.of(context).hoverColor,
      borderRadius: BorderRadius.circular(6),
    );
  }
}

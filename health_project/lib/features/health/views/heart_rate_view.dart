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
import 'package:health_project/features/health/views/vital_sign_history_view.dart';
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
  VitalSignDTO _lastValueDTO = VitalSignDTO(
      id: 'n/a', accountId: 0, value1: 0, value2: 0, time: 'n/a', type: 'n/a');
  late ChartType _chartType;
  late DateTime _time;

  _HeartRateView();

  @override
  void initState() {
    super.initState();
    _heartRateBloc = BlocProvider.of(context);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _time = DateTime.now();
    if (Provider.of<TabProvider>(context, listen: false).tabIndex == 0) {
      _chartType = ChartType.HOUR;
      _getEvents();
    } else {
      _chartType = ChartType.DAY;
      _getEvents();
    }
  }

  @override
  void dispose() {
    _heartValues.clear();
    _timeValues.clear();
    _animationController.dispose();
    super.dispose();
  }

  void _getEvents() {
    _heartValues.clear();
    _timeValues.clear();
    VitalSignDTO dto = VitalSignDTO(
      id: 'n/a',
      accountId: AuthenticateHelper.instance.getAccountId(),
      value1: 0,
      value2: 0,
      time: _time.toString(),
      type: VitalSignValueType.TYPE_HEART_RATE,
    );
    _heartRateBloc.add(HeartRateGetListEvent(dto: dto, chartType: _chartType));
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
                    if (state.lastValue.id != 'n/a') {
                      _lastValueDTO = state.lastValue;
                    }
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
                      GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          late Duration _duration;
                          if (_chartType == ChartType.DAY) {
                            _duration = Duration(days: 1);
                          } else {
                            _duration = Duration(hours: 1);
                          }
                          //
                          if (details.primaryVelocity! > 0) {
                            // User swiped Left d
                            _time = _time.subtract(_duration);
                            _getEvents();
                          } else if (details.primaryVelocity! < 0) {
                            // User swiped Right
                            if (DateTime.now().isAfter(_time.add(_duration))) {
                              _time = _time.add(_duration);
                              _getEvents();
                            }
                          }
                        },
                        child: Container(
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
                                final IntTween _rotationTween = IntTween(
                                    begin: 1, end: _heartValues.length);
                                _animation = _rotationTween
                                    .animate(_animationController)
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
                                          : _time.toString(),
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
                      ),
                      //last heart rate widget
                      (_lastValueDTO.id != 'n/a')
                          ? _buildLastHeartRate()
                          : Container(),
                      //show history heart rate button
                      InkWell(
                        onTap: () {
                          _buildVitalSignHistoryView();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          alignment: Alignment.center,
                          child: Text(
                            'Hiển thị thêm dữ liệu',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.BLUE_TEXT,
                              decoration: TextDecoration.underline,
                            ),
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
      ),
    );
  }

  Widget _buildLastHeartRate() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
      padding: EdgeInsets.all(20),
      decoration: DefaultTheme.cardDecoration(context),
      child: Row(
        children: [
          Text(
            'Nhịp tim gần đây: ',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Spacer(),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).hintColor,
              ),
              children: [
                TextSpan(
                  text: '${_lastValueDTO.value1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                TextSpan(
                  text: '\tBPM\n',
                  style: TextStyle(
                    color: Theme.of(context).shadowColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text:
                      '${TimeUtil.instance.formatHour(_lastValueDTO.time)} - ${TimeUtil.instance.formatBirthday(_lastValueDTO.time)}',
                  style: TextStyle(
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    int _max = 0, _min = 0;
    String currentHour = TimeUtil.instance.getHourToView(_time.toString());
    String nextHour = TimeUtil.instance.getNextHourToView(_time.toString());
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
                            : '${TimeUtil.instance.formatDateEvent(_time.toString(), 'T')}',
                      ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    (_chartType == ChartType.HOUR)
                        ? 'Không có dữ liệu\nTừ $currentHour - $nextHour'
                        : 'Không có dữ liệu\n${TimeUtil.instance.formatDateEvent(_time.toString(), 'T')}',
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
                        _time = DateTime.now();
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
                        _time = DateTime.now();
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

  _buildVitalSignHistoryView() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return VitalSignHistoryView(
            type: ChartType.ALL,
            valueType: VitalSignValueType.TYPE_HEART_RATE,
          );
        }).then((_) {
      if (_chartType == ChartType.HOUR) {
        Provider.of<TabProvider>(context, listen: false).updateTabIndex(0);
      } else {
        Provider.of<TabProvider>(context, listen: false).updateTabIndex(1);
      }
      _getEvents();
    });
  }

  void getEventsByTabIndex(int index) {
    if (index == 0) {
      _chartType = ChartType.HOUR;
      _getEvents();
    } else {
      _chartType = ChartType.DAY;
      _getEvents();
    }
  }

  BoxDecoration _selectedBox() {
    return BoxDecoration(
      color: Theme.of(context).hoverColor,
      borderRadius: BorderRadius.circular(6),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/utils/health_util.dart';
import 'package:health_project/features/health/blocs/health_bloc.dart';
import 'package:health_project/features/health/events/health_event.dart';
import 'package:health_project/features/health/states/health_state.dart';
import 'package:health_project/services/heart_rate_helper.dart';
import 'package:health_project/services/peripheral_helper.dart';

class HeartRateMeasureView extends StatefulWidget {
  const HeartRateMeasureView();

  @override
  State<StatefulWidget> createState() => _HeartRateMeasureView();
}

class _HeartRateMeasureView extends State<HeartRateMeasureView>
    with SingleTickerProviderStateMixin {
  late final HeartRateBloc _heartRateBloc;
  late AnimationController _animationController;
  int _value = 0, _min = 0, _max = 0;
  final List<int> _listHeartRate = [];
  @override
  void initState() {
    super.initState();

    _listHeartRate.clear();
    _heartRateBloc = BlocProvider.of(context);
    _heartRateBloc.add(HeartRateMeasureEvent(
        peripheralId: PeripheralHelper.instance.getPeripheralId()));
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: ClipRRect(
        child: Padding(
          padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33.33),
              color: Theme.of(context).hoverColor,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 130),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final Tween<double> _rotationTween =
                              Tween(begin: 1, end: 1.25);
                          return ScaleTransition(
                            scale: _rotationTween.animate(
                              CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.elasticOut),
                            ),
                            child: SizedBox(
                                height: 180,
                                width: 180,
                                child:
                                    Image.asset('assets/images/ic-heart.png')),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 60,
                        alignment: Alignment.centerRight,
                      ),
                      Text(
                        'Đo nhịp tim',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        duration: Duration(seconds: 20),
                        tween: Tween(begin: 15.0, end: 0.0),
                        builder: (context, animationValue, child) {
                          return InkWell(
                            onTap: () {
                              if (animationValue == 0) {
                                Navigator.of(context).pop(_value);
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 60,
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                (animationValue >= 1)
                                    ? '${animationValue.toInt()}s'
                                    : 'Xong',
                                style: TextStyle(
                                  color: (animationValue >= 1)
                                      ? Theme.of(context).shadowColor
                                      : DefaultTheme.BLUE_TEXT,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                BlocConsumer<HeartRateBloc, HealthState>(
                  listener: (context, state) {
                    if (state is HeartRateValueResponseState) {
                      print('heart rate: ${state.value} BPM');
                      _value = state.value;
                      _listHeartRate.add(_value);
                      if (_listHeartRate.isNotEmpty) {
                        _max = _listHeartRate
                            .reduce((curr, next) => curr > next ? curr : next);
                        _min = _listHeartRate
                            .reduce((curr, next) => curr < next ? curr : next);
                      }
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 70,
                          ),
                        ),
                        Spacer(),
                        Text(
                          (_value == 0) ? 'Đang đo' : '$_value BPM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: DefaultTheme.WHITE,
                            fontWeight: (_value == 0)
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                        ),
                        (_listHeartRate.isNotEmpty && _min != 0 && _max != 0)
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                height: 100,
                                alignment: Alignment.centerLeft,
                                decoration:
                                    DefaultTheme.cardDecoration(context),
                                child: Text(
                                  HealthUtil.instance.processHeartRateStatus(
                                      _min, _max, _value),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                              ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding:
                              EdgeInsets.only(left: 5, top: 10, bottom: 10),
                          height: 80,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lưu ý: Tuỳ vào tốc độ đọc cảm biến của thiết bị đeo mà nhịp tim ghi nhận giá trị trong khoảng 10 - 20 giây.',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).shadowColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 30,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

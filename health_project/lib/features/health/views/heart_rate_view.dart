import 'package:flutter/material.dart';

import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/constants/theme.dart';
import 'package:health_project/commons/widgets/header_widget.dart';
import 'package:health_project/commons/widgets/heart_rate_chart_painter.dart';

class HeartRateView extends StatefulWidget {
  const HeartRateView();

  @override
  State<StatefulWidget> createState() => _HeartRateView();
}

class _HeartRateView extends State<HeartRateView>
    with SingleTickerProviderStateMixin {
  //
  late AnimationController _animationController;
  late Animation<int> _animation;
  List<int> heartValues = [
    50,
    20,
    70,
    100,
    130,
    120,
    98,
    70,
    100,
  ];

  List<String> timeValues = [
    '01:05',
    '01:11',
    '01:13',
    '01:15',
    '01:16',
    '01:18',
    '01:25',
    '01:40',
    '01:50',
  ];

  _HeartRateView();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            SubHeader(title: 'Nhịp tim'),
            Expanded(
              child: ListView(
                children: [
                  _buildTabShowingType(),
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
                        final IntTween _rotationTween =
                            IntTween(begin: 1, end: heartValues.length);
                        _animation = _rotationTween
                            .animate(_animationController)
                          ..addStatusListener((status) {
                            if (status == AnimationStatus.completed) {
                              _animationController.stop();
                            } else if (status == AnimationStatus.dismissed) {
                              _animationController.forward();
                            }
                          });
                        _animationController.forward();
                        return CustomPaint(
                          painter: HeartRateChartPainter(
                            context: context,
                            edge: MediaQuery.of(context).size.width -
                                (DefaultNumeral.DEFAULT_MARGIN * 2),
                            currentTime: DateTime.now().toString(),
                            heartValues: heartValues,
                            timeValues: timeValues,
                            type: ChartType.HOUR,
                            valueLength: _animation.value,
                          ),
                        );
                      },
                    ),
                  ),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabShowingType() {
    int _max = heartValues.reduce((curr, next) => curr > next ? curr : next);
    int _min = heartValues.reduce((curr, next) => curr < next ? curr : next);
    print('max: $_max - min: $_min');
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
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
                  text: 'Từ 13:00 - 14:00',
                  style: TextStyle(
                      //color: Theme.of(context).shadowColor,
                      ),
                ),
              ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Giờ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 5)),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Ngày',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //  UnconstrainedBox(
    //   child: Container(
    //     width: 115,
    //     height: 30,
    //     padding: EdgeInsets.all(5),
    //     decoration: DefaultTheme.cardDecoration(context),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         //
    //         Container(
    //           width: 50,
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).hoverColor,
    //             borderRadius: BorderRadius.circular(6),
    //           ),
    //           child: Text(
    //             'Giờ',
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         Padding(padding: EdgeInsets.only(left: 5)),
    //         Container(
    //           width: 50,
    //           alignment: Alignment.center,
    //           child: Text(
    //             'Ngày',
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

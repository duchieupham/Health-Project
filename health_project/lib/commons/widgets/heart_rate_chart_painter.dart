import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/constants/numeral.dart';
import 'package:health_project/commons/utils/time_util.dart';

class HeartRateChartPainter extends CustomPainter {
  final BuildContext context;
  final double edge;
  final String currentTime;
  final List<int> heartValues;
  final List<String> timeValues;
  final ChartType type;
  final int valueLength;

  const HeartRateChartPainter({
    required this.context,
    required this.edge,
    required this.currentTime,
    required this.heartValues,
    required this.timeValues,
    required this.type,
    required this.valueLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //color to paint main line
    final Paint line = Paint()
      ..color = Theme.of(context).shadowColor.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Paint heartRateLine = Paint()
      ..color = Theme.of(context).indicatorColor.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Paint currentHeartRateDot = Paint()
      ..color = Theme.of(context).indicatorColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    final Paint lineHeartRate = Paint()
      ..color = Theme.of(context).indicatorColor
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    final Paint currentHeartRateDot2 = Paint()
      ..color = Theme.of(context).primaryColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    final Paint minmaxDot = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    //
    final double edgeWithPadding = edge - 20;
    //space of dot line
    final double space = 5;
    switch (type) {
      //GET CHART HOUR OF HEART RATE
      case ChartType.HOUR:
        //current hour is min value of line time
        String currentHour = TimeUtil.instance.getHour(currentTime);
        //
        final double pixelPerTimeUnit =
            edgeWithPadding / DefaultNumeral.UNIT_HOUR;
        final double pixelPerValueUnit =
            edgeWithPadding / DefaultNumeral.HEART_RATE_UNIT;

        ///
        ///------------------------------------
        //DRAW LINE OF CHART

        Offset maxHeartRatePoint = Offset(
            DefaultNumeral.UNIT_HOUR * pixelPerTimeUnit,
            (DefaultNumeral.HEART_RATE_UNIT - DefaultNumeral.HEART_RATE_UNIT) *
                pixelPerValueUnit);
        //
        Offset startPoint = Offset(DefaultNumeral.UNIT_HOUR * pixelPerTimeUnit,
            DefaultNumeral.HEART_RATE_UNIT * pixelPerValueUnit);
        //
        Offset startTimePoint =
            Offset(0, DefaultNumeral.UNIT_HOUR * pixelPerTimeUnit);
        //
        //horizontal line
        canvas.drawLine(startTimePoint, startPoint, line);
        for (int i = 0; i < DefaultNumeral.UNIT_HOUR; i++) {
          if (i % 15 == 0) {
            //draw dot line
            Offset tempDotLine = Offset(i * pixelPerTimeUnit, 0);

            for (int z = 0; z < DefaultNumeral.HEART_RATE_UNIT + 10; z++) {
              if (z % 2 == 0) {
                Offset dotLine =
                    Offset(i * pixelPerTimeUnit, z * pixelPerValueUnit);
                canvas.drawLine(dotLine, tempDotLine, line);
                tempDotLine =
                    Offset(i * pixelPerTimeUnit, z * pixelPerValueUnit + space);
              }
            }
            //draw text of heart value
            TextSpan heartRateLabel = TextSpan(
              text: TimeUtil.instance.formatTime(currentHour, i.toString()),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            );
            TextPainter descriptionPainter = TextPainter(
              text: heartRateLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            descriptionPainter.layout(
              minWidth: 40,
              maxWidth: 40,
            );
            Offset labelOffset = Offset(i * pixelPerTimeUnit,
                DefaultNumeral.UNIT_HOUR * pixelPerTimeUnit + 5);
            descriptionPainter.paint(canvas, labelOffset);
          }
        }

        //vertical line
        canvas.drawLine(maxHeartRatePoint, startPoint, line);

        for (int i = 0; i < DefaultNumeral.HEART_RATE_UNIT; i++) {
          if ((i + 1) % 50 == 0) {
            Offset tempDotLine = Offset(0,
                (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) * pixelPerValueUnit);
            //draw dot line
            for (int z = 0; z < DefaultNumeral.UNIT_HOUR; z++) {
              if (z % 1 == 0) {
                Offset dotLine = Offset(
                    z * pixelPerTimeUnit,
                    (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                        pixelPerValueUnit);
                canvas.drawLine(dotLine, tempDotLine, line);
                tempDotLine = Offset(
                    z * pixelPerTimeUnit + space,
                    (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                        pixelPerValueUnit);
              }
              //draw text of heart value
              TextSpan heartRateLabel = TextSpan(
                text: '${i.toInt() + 1}',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              );
              TextPainter descriptionPainter = TextPainter(
                text: heartRateLabel,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              );
              descriptionPainter.layout(
                minWidth: 50,
                maxWidth: 50,
              );
              Offset labelOffset = Offset(
                  DefaultNumeral.UNIT_HOUR * pixelPerTimeUnit - 40,
                  (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                          pixelPerValueUnit +
                      5);
              descriptionPainter.paint(canvas, labelOffset);
            }
          }
        }

        ///
        ///------------------------------------
        //DRAW LINE OF HEART RATE VALUE
        if (heartValues.isNotEmpty &&
            timeValues.isNotEmpty &&
            valueLength > 0) {
          List<int> indexValues =
              TimeUtil.instance.parseListTimeToIndexValues(timeValues);
          //Make sure that heartValues and timeValues is same length
          //so we can check only 1 range of list
          Offset tempPoint = Offset(0, 0);
          for (int i = 0; i < valueLength; i++) {
            Offset point = Offset(
                indexValues[i] * pixelPerTimeUnit,
                (DefaultNumeral.HEART_RATE_UNIT - heartValues[i]) *
                    pixelPerValueUnit);
            if (i == 0) {
              tempPoint = point;
            }
            canvas.drawLine(tempPoint, point, heartRateLine);
            tempPoint = point;
          }
          //draw dots and information values
          if (valueLength == heartValues.length) {
            //draw current value
            Offset currentHeartRatePoint = Offset(
                indexValues.last * pixelPerTimeUnit,
                (DefaultNumeral.HEART_RATE_UNIT - heartValues.last) *
                    pixelPerValueUnit);
            canvas.drawCircle(currentHeartRatePoint, 3, currentHeartRateDot);
            canvas.drawCircle(currentHeartRatePoint, 2, currentHeartRateDot2);
            //
            Offset heartRateLabelPosition = Offset(
                indexValues.last * pixelPerTimeUnit - 25,
                (heartValues.last >= (heartValues[heartValues.length - 2]))
                    ? ((DefaultNumeral.HEART_RATE_UNIT - heartValues.last) *
                            pixelPerValueUnit -
                        25)
                    : ((DefaultNumeral.HEART_RATE_UNIT - heartValues.last) *
                            pixelPerValueUnit +
                        10));
            TextSpan heartRateLabel = TextSpan(
              text: heartValues.last.toString(),
              style: TextStyle(
                color: Theme.of(context).indicatorColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            );
            TextPainter descriptionPainter = TextPainter(
              text: heartRateLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            descriptionPainter.layout(
              minWidth: 50,
              maxWidth: 50,
            );
            descriptionPainter.paint(canvas, heartRateLabelPosition);

            //draw min - max value
            int maxValue =
                heartValues.reduce((curr, next) => curr > next ? curr : next);
            int indexMax =
                heartValues.indexWhere((element) => element == maxValue);
            int minValue =
                heartValues.reduce((curr, next) => curr < next ? curr : next);
            int indexMin =
                heartValues.indexWhere((element) => element == minValue);

            Offset minHeartRatePoint = Offset(
                indexValues[indexMin] * pixelPerTimeUnit,
                (DefaultNumeral.HEART_RATE_UNIT - minValue) *
                    pixelPerValueUnit);
            Offset maxHeartRatePoint = Offset(
                indexValues[indexMax] * pixelPerTimeUnit,
                (DefaultNumeral.HEART_RATE_UNIT - maxValue) *
                    pixelPerValueUnit);
            canvas.drawCircle(minHeartRatePoint, 3, minmaxDot);
            canvas.drawCircle(minHeartRatePoint, 2, currentHeartRateDot2);
            canvas.drawCircle(maxHeartRatePoint, 3, minmaxDot);
            canvas.drawCircle(maxHeartRatePoint, 2, currentHeartRateDot2);
            //max label
            Offset maxLabelPosition = Offset(
                indexValues[indexMax] * pixelPerTimeUnit - 25,
                (DefaultNumeral.HEART_RATE_UNIT - maxValue) *
                        pixelPerValueUnit -
                    25);
            TextSpan maxLabel = TextSpan(
              text: maxValue.toString(),
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            );
            TextPainter maxPainter = TextPainter(
              text: maxLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            maxPainter.layout(
              minWidth: 50,
              maxWidth: 50,
            );
            maxPainter.paint(canvas, maxLabelPosition);
            //min label
            Offset minLabelPosition = Offset(
                indexValues[indexMin] * pixelPerTimeUnit - 25,
                (DefaultNumeral.HEART_RATE_UNIT - minValue) *
                        pixelPerValueUnit +
                    10);
            TextSpan minLabel = TextSpan(
              text: minValue.toString(),
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            );
            TextPainter minPainter = TextPainter(
              text: minLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            minPainter.layout(
              minWidth: 50,
              maxWidth: 50,
            );
            minPainter.paint(canvas, minLabelPosition);
          }
          //
        }
        break;

      //GET CHART DAY OF HEART RATE
      case ChartType.DAY:
        final double pixelPerTimeUnit =
            edgeWithPadding / DefaultNumeral.UNIT_DAY;
        final double pixelPerValueUnit =
            edgeWithPadding / DefaultNumeral.HEART_RATE_UNIT;

        //map list heartValues by time
        Map<int, List<int>> heartValuesMap = {};

        ///
        ///------------------------------------
        //DRAW LINE OF CHART

        Offset maxHeartRatePoint = Offset(
            DefaultNumeral.UNIT_DAY * pixelPerTimeUnit,
            (DefaultNumeral.HEART_RATE_UNIT - DefaultNumeral.HEART_RATE_UNIT) *
                pixelPerValueUnit);
        //
        Offset startPoint = Offset(DefaultNumeral.UNIT_DAY * pixelPerTimeUnit,
            DefaultNumeral.HEART_RATE_UNIT * pixelPerValueUnit);
        //
        Offset startTimePoint =
            Offset(0, DefaultNumeral.UNIT_DAY * pixelPerTimeUnit);
        //horizontal line
        canvas.drawLine(startTimePoint, startPoint, line);
        for (int i = 0; i < DefaultNumeral.UNIT_DAY; i++) {
          //add heart rate value into map with key = i
          heartValuesMap[i] = [];
          if (heartValues.length == timeValues.length) {
            for (int y = 0; y < timeValues.length; y++) {
              if (int.parse(timeValues[y].split(':')[0]) == i) {
                heartValuesMap[i]!.add(heartValues[y]);
              }
            }
          }

          //
          if (i % 6 == 0) {
            //draw dot line
            Offset tempDotLine = Offset(i * pixelPerTimeUnit, 0);

            for (int z = 0; z < DefaultNumeral.HEART_RATE_UNIT + 10; z++) {
              if (z % 2 == 0) {
                Offset dotLine =
                    Offset(i * pixelPerTimeUnit, z * pixelPerValueUnit);
                canvas.drawLine(dotLine, tempDotLine, line);
                tempDotLine =
                    Offset(i * pixelPerTimeUnit, z * pixelPerValueUnit + space);
              }
            }
            //draw text of heart value
            TextSpan heartRateLabel = TextSpan(
              text: TimeUtil.instance.formatTime(i.toString(), '00'),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            );
            TextPainter descriptionPainter = TextPainter(
              text: heartRateLabel,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            descriptionPainter.layout(
              minWidth: 40,
              maxWidth: 40,
            );
            Offset labelOffset = Offset(i * pixelPerTimeUnit,
                DefaultNumeral.UNIT_DAY * pixelPerTimeUnit + 5);
            descriptionPainter.paint(canvas, labelOffset);
          }

          if (heartValuesMap[i]!.isNotEmpty) {
            //draw line showing min -max
            if (heartValuesMap[i]!.length > 1) {
              int minValue = heartValuesMap[i]!
                  .reduce((curr, next) => curr < next ? curr : next);
              int maxValue = heartValuesMap[i]!
                  .reduce((curr, next) => curr > next ? curr : next);
              print('at $i:00 o"clock, min: $minValue - max: $maxValue');
              double averageValue = (minValue + maxValue) / 2;
              Offset minPoint = Offset(
                  i * pixelPerTimeUnit,
                  (DefaultNumeral.HEART_RATE_UNIT - minValue) *
                      pixelPerValueUnit);
              Offset maxPoint = Offset(
                  i * pixelPerTimeUnit,
                  (DefaultNumeral.HEART_RATE_UNIT - maxValue) *
                      pixelPerValueUnit);
              Offset averagePoint = Offset(
                  i * pixelPerTimeUnit,
                  (DefaultNumeral.HEART_RATE_UNIT - averageValue) *
                      pixelPerValueUnit);
              canvas.drawLine(minPoint, maxPoint, lineHeartRate);
              // canvas.drawOval(
              //   Rect.fromCenter(
              //     center: averagePoint,
              //     width: 3,
              //     height: averageValue * pixelPerValueUnit,
              //   ),
              //   currentHeartRateDot,
              // );
            }
            //draw dot showing value
            else {
              print('at $i:00 o"clock, value: ${heartValuesMap[i]!.first}');
              Offset currentHeartRatePoint = Offset(
                  i * pixelPerTimeUnit,
                  (DefaultNumeral.HEART_RATE_UNIT - heartValuesMap[i]!.first) *
                      pixelPerValueUnit);
              canvas.drawCircle(currentHeartRatePoint, 3, currentHeartRateDot);
            }
          }
        }
        print('heartValuesMap: $heartValuesMap');

        //vertical line
        canvas.drawLine(maxHeartRatePoint, startPoint, line);
        for (int i = 0; i < DefaultNumeral.HEART_RATE_UNIT; i++) {
          if ((i + 1) % 50 == 0) {
            Offset tempDotLine = Offset(0,
                (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) * pixelPerValueUnit);
            //draw dot line
            for (int z = 0; z < DefaultNumeral.UNIT_DAY; z++) {
              if (z % 1 == 0) {
                Offset dotLine = Offset(
                    z * pixelPerTimeUnit,
                    (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                        pixelPerValueUnit);
                canvas.drawLine(dotLine, tempDotLine, line);
                tempDotLine = Offset(
                    z * pixelPerTimeUnit + space * 3,
                    (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                        pixelPerValueUnit);
              }
              //draw text of heart value
              TextSpan heartRateLabel = TextSpan(
                text: '${i.toInt() + 1}',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              );
              TextPainter descriptionPainter = TextPainter(
                text: heartRateLabel,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              );
              descriptionPainter.layout(
                minWidth: 50,
                maxWidth: 50,
              );
              Offset labelOffset = Offset(
                  DefaultNumeral.UNIT_DAY * pixelPerTimeUnit - 40,
                  (DefaultNumeral.HEART_RATE_UNIT - (i + 1)) *
                          pixelPerValueUnit +
                      5);
              descriptionPainter.paint(canvas, labelOffset);
            }
          }
        }
        //
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

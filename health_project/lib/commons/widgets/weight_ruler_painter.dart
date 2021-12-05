import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';

class WeightRulerPainter extends CustomPainter {
  final BuildContext context;
  final double width;
  final double height;
  final double weight;

  const WeightRulerPainter({
    required this.context,
    required this.width,
    required this.height,
    required this.weight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //
    final Paint markLine = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Paint subLine = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Paint weightLine = Paint()
      ..color = DefaultTheme.RED_CALENDAR.withOpacity(0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Paint circlePaint = Paint()
      ..color = Theme.of(context).hoverColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //text
    final TextSpan valueText = TextSpan(
      text: '${weight.toInt()} kg',
      style: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 15,
      ),
    );
    final valuePainter = TextPainter(
      text: valueText,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    //space of value
    final double space = 20;
    //
    final double marginVerical = height * 1 / 4;
    double min = ((weight ~/ 10) * 10) - space / 2;
    double max = ((weight ~/ 10) * 10) + space;
    double unit = max - min;
    double pixelPerUnit = width / unit;
    double weightValue = (weight - min) * pixelPerUnit;
    //draw ruler
    for (double i = min; i <= max; i++) {
      if (i % 10 == 0) {
        Offset upperDot = Offset((i - min) * pixelPerUnit, marginVerical);
        Offset lowerDot =
            Offset((i - min) * pixelPerUnit, height - marginVerical);
        canvas.drawLine(upperDot, lowerDot, markLine);
        Offset lowerDot2 = Offset((i - min) * pixelPerUnit - 25, height - 20);
        canvas.drawLine(upperDot, lowerDot, markLine);
        //draw description text
        TextSpan descriptionText = TextSpan(
          text: '${i.toInt()} kg',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 10,
          ),
        );
        TextPainter descriptionPainter = TextPainter(
          text: descriptionText,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        descriptionPainter.layout(
          minWidth: 50,
          maxWidth: 50,
        );
        descriptionPainter.paint(canvas, lowerDot2);
      } else if (i % 5 == 0 && i % 10 != 0) {
        Offset upperDot =
            Offset((i - min) * pixelPerUnit, (marginVerical + 10));
        Offset lowerDot =
            Offset((i - min) * pixelPerUnit, height - (marginVerical + 10));
        canvas.drawLine(upperDot, lowerDot, subLine);
      }
    }
    //draw current value line
    Offset weightUpperDot = Offset(weightValue, marginVerical - 10);
    Offset weightLowerDot = Offset(weightValue, height - (marginVerical - 10));
    canvas.drawLine(weightUpperDot, weightLowerDot, weightLine);

    //draw current value oval
    Offset weightOffset = Offset(weightValue, height / 2);
    canvas.drawOval(
        Rect.fromCenter(center: weightOffset, width: 70, height: 30),
        weightLine);
    canvas.drawOval(
        Rect.fromCenter(center: weightOffset, width: 70, height: 30),
        circlePaint);
    //draw current value text
    //-25 for width of text; -7.5 for height of text
    Offset textOffset = Offset(weightValue - 25, height / 2 - 7.5);
    valuePainter.layout(
      minWidth: 50,
      maxWidth: 50,
    );
    valuePainter.paint(canvas, textOffset);
    //
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

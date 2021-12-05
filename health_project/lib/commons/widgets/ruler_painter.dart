import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';

class RulerPainter extends CustomPainter {
  final BuildContext context;
  final double width;
  final double min;
  final double max;
  final double value;

  const RulerPainter({
    required this.context,
    required this.width,
    required this.min,
    required this.max,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //
    final Paint line = Paint()
      ..color = Theme.of(context).hintColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint markLine = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint currentMark = Paint()
      ..color = DefaultTheme.RED_CALENDAR
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final Path path = Path();

    //
    double centerValue = width / 2;
    double unit = max - min;
    double pixelPerUnit = width / unit;
    double currentValue = (value - min) * pixelPerUnit;
    // print(
    //     'unit: $unit - pixel per unit: $pixelPerUnit - currentValue: $currentValue');

    //
    Offset minOffset = Offset(0, centerValue);
    Offset minOffsetMark = Offset(0, centerValue + 5);
    Offset minOffsetMark2 = Offset(0, centerValue - 5);
    Offset maxOffset = Offset(width, centerValue);
    Offset maxOffsetMark = Offset(width, centerValue + 5);
    Offset maxOffsetMark2 = Offset(width, centerValue - 5);

    //Offset of current value based on unit and min-max
    Offset valueOffset = Offset(currentValue, centerValue);
    Offset valueTextOffset = Offset(currentValue - 25, centerValue - 50);
    Offset valueTexDesctOffset = Offset(currentValue - 25, centerValue - 30);
    Offset valueOffsettMark = Offset(currentValue - 3, centerValue - 10);
    Offset valueOffsettMark2 = Offset(currentValue + 3, centerValue - 10);

    canvas.drawLine(minOffsetMark, minOffsetMark2, markLine);
    canvas.drawLine(maxOffsetMark, maxOffsetMark2, markLine);
    canvas.drawLine(minOffset, maxOffset, line);
    //
    path.moveTo(valueOffset.dx, valueOffset.dy);
    path.lineTo(valueOffsettMark.dx, valueOffsettMark.dy);
    path.lineTo(valueOffsettMark2.dx, valueOffsettMark2.dy);
    path.lineTo(valueOffset.dx, valueOffset.dy);
    canvas.drawPath(path, currentMark);
    // canvas.drawLine(valueOffset, valueOffsettMark, currentMark);

    //
    final textStyle = TextStyle(
      color: Theme.of(context).hintColor,
      fontSize: 18,
    );
    final textStyleDesc = TextStyle(
      color: Theme.of(context).hintColor,
      fontSize: 12,
    );
    final TextSpan valueText = TextSpan(
      text: '${value.toInt() / 1000}',
      style: textStyle,
    );
    final TextSpan descText = TextSpan(
      text: 'hPa',
      style: textStyleDesc,
    );
    final valuePainter = TextPainter(
      text: valueText,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final descPainter = TextPainter(
      text: descText,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    valuePainter.layout(
      minWidth: 50,
      maxWidth: 50,
    );
    descPainter.layout(
      minWidth: 50,
      maxWidth: 50,
    );
    valuePainter.paint(canvas, valueTextOffset);
    descPainter.paint(canvas, valueTexDesctOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_project/commons/constants/theme.dart';

// FOR PAINTING THE CIRCLE
class CirclePainter extends CustomPainter {
  final BuildContext context;
  final double diameter;

  const CirclePainter({
    required this.context,
    required this.diameter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = diameter / 2;
    //
    final Paint subLine = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    //
    final Paint line = Paint()
      ..color = Theme.of(context).hintColor.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    //
    final Path path = Path();
    List<int> celsius = Iterable<int>.generate(360).toList();

    //
    Offset center = Offset(radius, radius);
    //move path to center
    path.moveTo(center.dx, center.dy);
    for (var i in celsius) {
      //2 offets for draw lines of circle
      Offset iOffset = Offset(
        radius * -sin(i / (180 / pi)) + center.dx,
        radius * -cos(i / (180 / pi)) + center.dy,
      );
      Offset iOffset2 = Offset(
        radius / 1.2 * -sin(i / (180 / pi)) + center.dx,
        radius / 1.2 * -cos(i / (180 / pi)) + center.dy,
      );
      if (i % 5 == 0) {
        canvas.drawLine(iOffset, iOffset2, subLine);
      }
      if (i % 45 == 0) {
        canvas.drawLine(iOffset, iOffset2, line);
      } else {
        path.close();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//FOR PAINTING RED DOT DIRECTION
class DirectionPainter extends CustomPainter {
  final BuildContext context;
  final double diameter;
  final double direction;

  const DirectionPainter({
    required this.context,
    required this.diameter,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    ///
    final double radius = diameter / 2;
    //
    Paint pointPaint = Paint()
      ..color = DefaultTheme.RED_CALENDAR
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    //
    final Path path = Path();
    Offset center = Offset(radius, radius);

    // formula: O(x,y) has Ox = radius * cos(radians) - Oy = radius * sin(radians)
    //Setting top is 0 celsius, so has Ox = radius * -sin(radians) - Oy = radius * -cos(radians)
    //because of center move to center of container, so + center.dx(dy)
    //1 radian = 180/pi (celsius)
    Offset pointOnCircle = Offset(
      radius * -sin(direction / (180 / pi)) + center.dx,
      radius * -cos(direction / (180 / pi)) + center.dy,
    );

    Offset subPoint1 = Offset(
      radius / 1.25 * -sin((direction - 5) / (180 / pi)) + center.dx,
      radius / 1.25 * -cos((direction - 5) / (180 / pi)) + center.dy,
    );
    Offset subPoint2 = Offset(
      radius / 1.25 * -sin((direction + 5) / (180 / pi)) + center.dx,
      radius / 1.25 * -cos((direction + 5) / (180 / pi)) + center.dy,
    );

    //move path to center of container
    path.moveTo(center.dx, center.dy);
    //
    path.lineTo(pointOnCircle.dx, pointOnCircle.dy);
    //
    path.lineTo(subPoint1.dx, subPoint1.dy);
    path.lineTo(subPoint2.dx, subPoint2.dy);
    path.lineTo(pointOnCircle.dx, pointOnCircle.dy);
    //
    canvas.drawPath(path, pointPaint);
    //
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

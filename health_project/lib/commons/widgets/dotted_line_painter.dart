import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  // late Paint _paint;
  final BuildContext context;
  final Color color;
  final double thickness;
  //
  const DottedLinePainter({
    required this.context,
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint();
    _paint.color = color; //dots color
    _paint.strokeWidth = thickness; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
    final double width = MediaQuery.of(context).size.width;
    for (double i = -width; i < width; i = i + 15) {
      // 15 is space between dots
      if (i % 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  final List<int> listBubble;
  final double size;

  const BubblePainter({required this.listBubble, required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return listBubble.contains(listBubble.where((element) => true));
  }
}

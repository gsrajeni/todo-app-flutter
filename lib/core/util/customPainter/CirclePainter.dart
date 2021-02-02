import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  Color color;

  CirclePainter(this.color);

  var _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color;
    _paint.strokeWidth = 2;
    _paint.style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

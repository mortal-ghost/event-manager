import 'dart:math';
import 'package:flutter/material.dart';

class SpritePainter extends CustomPainter {
  late final Animation<double> animation;

  SpritePainter(this.animation) : super(repaint: animation);

  void circle(Canvas canvas, Rect rect, double val) {
    double opacity = (1.0 - (val/4)).clamp(0.0, 1.0);
    Color color = Colors.blue.withOpacity(opacity);

    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * val / 4);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    for (int i = 0; i < 4; i++) {
      circle(canvas, rect, animation.value + i);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) => false;
}
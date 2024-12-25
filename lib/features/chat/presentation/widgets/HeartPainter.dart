import 'package:flutter/material.dart';

import '../../domain/enitity/Heart.dart';

class HeartPainter extends CustomPainter {
  final List<Heart> hearts;

  HeartPainter(this.hearts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var heart in hearts) {
      heart.updatePosition(size);

      // Draw heart shape
      paint.color = heart.color;
      _drawHeart(canvas, paint, heart.position, heart.size);
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();

    path.moveTo(center.dx, center.dy);
    path.cubicTo(
      center.dx - size / 2,
      center.dy - size / 2,
      center.dx - size,
      center.dy + size / 3,
      center.dx,
      center.dy + size,
    );
    path.cubicTo(
      center.dx + size,
      center.dy + size / 3,
      center.dx + size / 2,
      center.dy - size / 2,
      center.dx,
      center.dy,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

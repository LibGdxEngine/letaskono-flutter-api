import 'package:flutter/material.dart';
import 'dart:ui' as ui; // For using ui.Image
import 'dart:math';

class WelcomePainter extends CustomPainter {
  final Color color;
  final Color innerColor;
  final Color innerCircleColor;
  final List<ui.Image> images; // List of images to be drawn
  final List<Offset> positions; // Positions for the images
  final List<double> sizes; // Sizes for the circular images

  WelcomePainter({
    required this.color,
    required this.innerColor,
    required this.innerCircleColor,
    required this.images,
    required this.positions,
    required this.sizes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Paint for the dashed circle
    final dashedPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    // Parameters for the dashed circle
    const double radius = 150;
    const double dashLength = 12;
    const double gapLength = 10;

    final Path dashedPath = Path();

    // Calculate dashes
    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashLength + gapLength)).floor();
    final double angleStep = (2 * pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * angleStep;
      final double endAngle = startAngle + (dashLength / radius);

      final double startX = center.dx + radius * cos(startAngle);
      final double startY = center.dy + radius * sin(startAngle);
      final double endX = center.dx + radius * cos(endAngle);
      final double endY = center.dy + radius * sin(endAngle);

      dashedPath.moveTo(startX, startY);
      dashedPath.lineTo(endX, endY);
    }

    canvas.drawPath(dashedPath, dashedPaint);

    // Paint for the larger inner circle
    final largeCirclePaint = Paint()
      ..color = innerColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.68, largeCirclePaint);

    // Paint for the smaller inner circle
    final smallCirclePaint = Paint()
      ..color = innerCircleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, smallCirclePaint);

    // Draw circular images
    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final position = positions[i];
      final size = sizes[i];

      // Draw the image as a circle
      final Rect rect = Rect.fromCircle(center: position, radius: size / 2);

      final Path path = Path()..addOval(rect);
      final Paint imagePaint = Paint();
      // Save the canvas state
      canvas.save();
      // Clip the canvas to the circular path (only for this image)
      canvas.clipPath(path);

      // canvas.clipPath(Path()..addOval(rect)); // Clip the image to a circular shape
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), // Source rect
        rect, // Destination rect
        imagePaint,
      );
      // Restore the canvas state (removes the clipping)
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Set to true to repaint when images or other properties change
  }
}

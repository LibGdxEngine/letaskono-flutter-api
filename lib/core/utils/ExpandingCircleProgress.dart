import 'package:flutter/material.dart';

class ExpandingCircleProgress extends StatefulWidget {
  @override
  _ExpandingCircleProgressState createState() =>
      _ExpandingCircleProgressState();
}

class _ExpandingCircleProgressState extends State<ExpandingCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleExpansion;

  final List<double> _radii = [
    10,
    20,
    30,
  ]; // Different radii for each circle

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 1), // Shorter animation for quicker expansion
    );

    _circleExpansion = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Repeat the animation infinitely
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(50, 50), // Size of the canvas
            painter: SolidCirclePainter(
              color: Theme.of(context).colorScheme.primary,
              expansion: _circleExpansion.value,
              radii: _radii,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SolidCirclePainter extends CustomPainter {
  final double expansion;
  final List<double> radii;
  final Color color;

  SolidCirclePainter(
      {required this.expansion, required this.radii, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()
      ..color = color // Set to any color you desire
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke; // Solid line

    // Loop through each circle with different radii
    for (double radius in radii) {
      // Calculate the radius expansion for each circle
      final double currentRadius =
          expansion * (radius / radii.last); // Adjust based on expansion

      // Draw the circle with a solid stroke
      canvas.drawCircle(center, currentRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every frame to animate
  }
}
